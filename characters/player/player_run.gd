extends State

@export var SPEEDMULTIPLIER = 2.0

func _enter_tree() -> void:
	state_name = "run"
	state_machine = get_parent()

func input_handle_state(event : InputEvent) -> String:
	if event.is_action_released("Run"):
		return "walk"
	return state_name

func process_state(delta : float) -> String:
	if controlled_character.direction == Vector2.ZERO:
		return "idle"
	return state_name

func physics_process_state(delta : float) -> String:
	controlled_character.velocity = controlled_character.direction * controlled_character.stats.speed * SPEEDMULTIPLIER
	return state_name
