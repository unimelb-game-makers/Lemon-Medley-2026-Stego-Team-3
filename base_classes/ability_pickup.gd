extends Area2D
class_name AbilityPickup

@export var ability_scene: PackedScene

@onready var label: Label = $Label

func get_ability() -> Ability:
	return ability_scene.instantiate()

func open_label():
	label.visible = true

func close_label():
	label.visible = false
