extends State

func initialize(character : Character):
	if character is Player:
		controlled_character = character
	else:
		assert_wrong_character(character, Player)

func _enter_tree() -> void:
	state_name = "idle"
	state_machine = get_parent()

func process_state(delta : float) -> String:
	if controlled_character.direction != Vector2.ZERO:
		return "walk"
	return state_name

func input_handle_state(event : InputEvent) -> String:
	if event.is_action_pressed("Melee"):
		return "idle_attack"
	
	if event.is_action_pressed("Interact"):
		PlayerManager.interact()
		
	return state_name

func physics_process_state(delta : float) -> String:
	controlled_character.velocity = Vector2.ZERO
	return state_name
