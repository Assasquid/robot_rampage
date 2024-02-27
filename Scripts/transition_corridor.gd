extends Node3D

@onready var exterior_transition_corridor: CSGBox3D = $ExteriorTransitionCorridor
@onready var transition_wall: CSGPolygon3D = $InteriorTransitionCorridor/CSGCombiner3D2/TransitionWall
@onready var interior_transition_corridor: CSGBox3D = $InteriorTransitionCorridor


func _ready() -> void:
	transition_wall.flip_faces = true


func _on_handle_transition_wall_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		#interior_transition_corridor.use_collision = false
		
		body.add_collision_exception_with(interior_transition_corridor)
		print(body.get_collision_exceptions())
		print("Opening the door.")


func _on_handle_transition_wall_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		#interior_transition_corridor.use_collision = true
		body.remove_collision_exception_with(interior_transition_corridor)
		print(body.get_collision_exceptions())
		print("Closing the door.")


func _on_handle_visibility_transition_wall_inside_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		transition_wall.flip_faces = false


func _on_handle_visibility_transition_wall_outside_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		transition_wall.flip_faces = true
