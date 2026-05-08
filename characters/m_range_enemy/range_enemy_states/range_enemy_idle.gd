extends State

func _enter_tree() -> void:
	state_name = "idle"
	state_machine = get_parent()

func on_enter() -> void:
	controlled_character.velocity = Vector2.ZERO

func process_state(delta : float) -> String:
	return state_name
