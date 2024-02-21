extends Node3D

@export var weapon_mesh: Node3D
@export var fire_rate := 14.0
@export var recoil := 0.05
@export var recoil_lerp_amount := 10.0

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_position: Vector3 = weapon_mesh.position
@onready var ray_cast_3d: RayCast3D = $RayCast3D


func _process(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		if cooldown_timer.is_stopped():
			shoot()
	
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position, delta * recoil_lerp_amount)


func shoot() -> void:
	cooldown_timer.start(1.0 / fire_rate)
	printt("Weapon fired!", ray_cast_3d.get_collider())
	weapon_mesh.position.z += recoil
