extends State

@export var SPEEDMULTIPLIER : float = 2.0

func initialize(character : Character):
	if character is Player:
		controlled_character = character
	else:
		assert_wrong_character(character, Player)

func _enter_tree() -> void:
	state_name = "dash_attack"
	state_machine = get_parent()

func on_enter() -> void:
	if !controlled_character.attacking:
		controlled_character.attack()
	
	# Check if we are entering this state from a non dashing state.
	# If we entered from dash_attack, we do not want to start dash_timer again.
	if controlled_character.dash_timer.is_stopped():
		controlled_character.dash_timer.start()
		controlled_character.is_dashing = true
		controlled_character.dash_vector = controlled_character.last_direction
		controlled_character.can_dash = false

func process_state(delta : float) -> String:
	# While we are attacking, if we input another attack we buffer it and attack again after
	# the current one ends
	if !controlled_character.attacking and controlled_character.attack_buffered:
		controlled_character.attack()
		controlled_character.attack_buffered = false
	
	if !controlled_character.is_dashing:
		if !controlled_character.attacking:
			return "idle"
		return "idle_attack"
	
	if !controlled_character.attacking:
		return "dash"	
	
	return state_name

func input_handle_state(event : InputEvent) -> String:
	if event.is_action_pressed("Melee"):
		controlled_character.attack_buffered = true
	return state_name

func physics_process_state(delta : float) -> String:
	controlled_character.velocity = controlled_character.dash_vector * controlled_character.stats.speed * SPEEDMULTIPLIER
	controlled_character.velocity += controlled_character.direction * controlled_character.stats.speed
	return state_name
