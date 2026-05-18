extends Area2D
class_name AbilityPickup

@export var ability_scene: PackedScene
@export var ability_text: String

func get_ability() -> Ability:
	return ability_scene.instantiate()
