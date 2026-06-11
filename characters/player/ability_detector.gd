extends Area2D
class_name AbilityDetector

@export var ability_manager: AbilityManager

var current_pickup: AbilityPickup

## To be called in Player parent script
func input_handling(event: InputEvent):
	if current_pickup and event.is_action_pressed("Interact"):
		ability_manager.add_ability(current_pickup.get_ability())
		current_pickup.queue_free()
		current_pickup = null

func _on_area_entered(area: Area2D) -> void:
	if area is AbilityPickup:
		current_pickup = area
		area.open_label()

func _on_area_exited(area: Area2D) -> void:
	if area is AbilityPickup:
		current_pickup = null
		area.close_label()
