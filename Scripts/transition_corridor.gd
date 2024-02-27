extends Node3D

@onready var exterior_transition_corridor: CSGBox3D = $ExteriorTransitionCorridor


func _ready() -> void:
	exterior_transition_corridor.visible = true
	exterior_transition_corridor.use_collision = true


func _on_make_exterior_disappear_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		exterior_transition_corridor.visible = false
		exterior_transition_corridor.use_collision = false


func _on_make_exterior_reappear_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		exterior_transition_corridor.visible = true
		exterior_transition_corridor.use_collision = true
