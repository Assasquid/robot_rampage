extends Node
class_name AmmoHandler

@export var ammo_label: Label

enum ammo_type {
	BULLET,
	SMALL_BULLET
}

var ammo_storage := {
	ammo_type.BULLET: 20,
	ammo_type.SMALL_BULLET: 120 
}

func has_ammo(type: ammo_type) -> bool:
	return ammo_storage[type] > 0


func use_ammo(type: ammo_type) -> void:
	if has_ammo(type):
		ammo_storage[type] -= 1
		update_ammo_label(type)


func update_ammo_label(type: ammo_type) -> void:
	ammo_label.text = str(ammo_storage[type])
