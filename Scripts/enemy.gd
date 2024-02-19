extends CharacterBody3D

@export var aggro_range := 12.0

const SPEED = 4.42

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var player
var provoked := false

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _process(_delta: float) -> void:
	if provoked:
		navigation_agent_3d.target_position = player.global_position


func _physics_process(delta: float) -> void:
	var next_position = navigation_agent_3d.get_next_path_position()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = global_position.direction_to(next_position)
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= aggro_range:
		provoked = true
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
