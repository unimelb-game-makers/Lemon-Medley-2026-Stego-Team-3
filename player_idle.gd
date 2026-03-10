extends State

func _enter_tree() -> void:
	state_name = "idle"
	state_machine = get_parent()

func process_state(delta : float) -> String:
	if controlled_character.direction != Vector2.ZERO:
		return "walk"
	return state_name

func physics_process_state(delta : float) -> String:
	controlled_character.velocity = Vector2.ZERO
	return state_name
