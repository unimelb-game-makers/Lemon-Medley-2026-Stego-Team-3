extends State

func initialize(character : Character):
	if character is Player:
		controlled_character = character
	else:
		assert_wrong_character(character, Player)

func _enter_tree() -> void:
	state_name = "dialogue"
	state_machine = get_parent()

func physics_process_state(delta : float) -> String:
	controlled_character.velocity = Vector2.ZERO
	return state_name
