extends Control

@onready var progress_bar = $TextureProgressBar
var attached_ability : Ability = null

func attach(ability : Ability):
	attached_ability = ability
	progress_bar.max_value = attached_ability.cooldown_timer.wait_time
	
func _process(delta: float) -> void:
	if attached_ability == null:
		return
	
	progress_bar.value = (progress_bar.max_value - attached_ability.cooldown_timer.time_left)
