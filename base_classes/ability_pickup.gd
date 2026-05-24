extends Area2D
class_name AbilityPickup

@export var ability_scene: PackedScene

func get_ability() -> Ability:
	return ability_scene.instantiate()
