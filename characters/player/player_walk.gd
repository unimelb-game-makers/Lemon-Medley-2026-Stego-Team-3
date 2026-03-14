extends State

func initialize(character : Character):
	if character is Player:
		controlled_character = character
	else:
		assert_wrong_character(character, Player)

func _enter_tree() -> void:
	state_name = "walk"
	state_machine = get_parent()

func physics_process_state(delta : float):
	controlled_character.velocity = controlled_character.direction * controlled_character.stats.speed
	return state_name

func input_handle_state(event : InputEvent):
	if event.is_action_pressed("Melee"):
		return "walk_attack"
	
	return state_name

func process_state(delta : float):
	if Input.is_action_pressed("Run"):
		return "run"
		
	if controlled_character.direction == Vector2.ZERO:
		return "idle"
	return state_name
