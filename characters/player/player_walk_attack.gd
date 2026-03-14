extends State

func initialize(character : Character):
	if character is Player:
		controlled_character = character
	else:
		assert_wrong_character(character, Player)

func _enter_tree() -> void:
	state_name = "walk_attack"
	state_machine = get_parent()

func on_enter() -> void:
	if !controlled_character.attacking:
		controlled_character.attack()

func process_state(delta : float) -> String:
	# While we are attacking, if we input another attack we buffer it and attack again after
	# the current one ends
	if !controlled_character.attacking and controlled_character.attack_buffered:
		controlled_character.attack()
		controlled_character.attack_buffered = false
		
	if !controlled_character.attacking:
		return "idle"	
	
	if controlled_character.direction == Vector2.ZERO:
		return "idle_attack"
	
	if Input.is_action_pressed("Run"):
		return "run_attack"
	
	return state_name

func input_handle_state(event : InputEvent) -> String:
	if event.is_action_pressed("Melee"):
		controlled_character.attack_buffered = true
	return state_name

func physics_process_state(delta : float) -> String:
	controlled_character.velocity = controlled_character.direction * controlled_character.stats.speed
	return state_name
