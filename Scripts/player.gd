extends CharacterBody3D
class_name Player

@export var mouse_sensitivity := 0.001
@export var max_health := 100
@export var aim_multiplier := 0.7
@export var aim_mouse_motion_multiplier := 0.4
@export var aim_speed_multiplier := 0.54
@export var lerp_value_in := 19.0
@export var lerp_value_out := 42.0

## This is to control the feel of the jump. It modifies the gravity when falling back down.
@export var fall_multiplier := 2.6
@export var jump_height := 1.0

const SPEED = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO
var health: int = max_health:
	set(new_value):
		if new_value < health:
			damage_animation_player.stop(false)
			damage_animation_player.play("TakeDamage")
		health = new_value
		print(health)
		if health <= 0:
			game_over_menu.game_over()

@onready var camera_pivot: Node3D = $CameraPivot
@onready var damage_animation_player: AnimationPlayer = $DamageTexture/DamageAnimationPlayer
@onready var game_over_menu: Control = $GameOverMenu
@onready var ammo_handler: AmmoHandler = %AmmoHandler
@onready var smooth_camera: Camera3D = %SmoothCamera
@onready var weapon_camera: Camera3D = %WeaponCamera

@onready var smooth_camera_fov := smooth_camera.fov
@onready var weapon_camera_fov := weapon_camera.fov


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	if Input.is_action_pressed("aim"):
		smooth_camera.fov = lerp(
			smooth_camera.fov,
			smooth_camera_fov * aim_multiplier,
			delta * lerp_value_in
			)
		weapon_camera.fov = lerp(
			weapon_camera.fov,
			weapon_camera_fov * aim_multiplier,
			delta * lerp_value_in
			)
	else:
		smooth_camera.fov = lerp(
			smooth_camera.fov,
			smooth_camera_fov,
			delta * lerp_value_out
			)
		weapon_camera.fov = lerp(
			weapon_camera.fov,
			weapon_camera_fov,
			delta * lerp_value_out
			)

func _physics_process(delta: float) -> void:
	handle_camera_rotation()
	
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2.0 * gravity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if Input.is_action_pressed("aim"):
			velocity.x *= aim_speed_multiplier
			velocity.z *= aim_speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_motion = -event.relative * mouse_sensitivity
		if Input.is_action_pressed("aim"):
			mouse_motion *= aim_mouse_motion_multiplier
		
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x, -90.0, 90.0
	)
	mouse_motion = Vector2.ZERO
