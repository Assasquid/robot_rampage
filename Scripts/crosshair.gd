@tool
extends Control

@export var reticle_circle_radius := 2
@export var reticle_circle_shadow_radius := 3

@export var crosshair_line_origin := 16
@export var crosshair_line_destination := 24
@export var crosshair_line_width := 2




func _draw() -> void:
	draw_circle(Vector2.ZERO, reticle_circle_shadow_radius, Color.DIM_GRAY)
	draw_circle(Vector2.ZERO, reticle_circle_radius, Color.WHITE)
	
	draw_line(Vector2(crosshair_line_origin, 0), Vector2(crosshair_line_destination, 0), Color.WHITE, crosshair_line_width)
	draw_line(Vector2(-crosshair_line_origin, 0), Vector2(-crosshair_line_destination, 0), Color.WHITE, crosshair_line_width)
	draw_line(Vector2(0, crosshair_line_origin), Vector2(0, crosshair_line_destination), Color.WHITE, crosshair_line_width)
	draw_line(Vector2(0, -crosshair_line_origin), Vector2(0, -crosshair_line_destination), Color.WHITE, crosshair_line_width)
	
