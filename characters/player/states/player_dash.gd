extends State

@export var SPEEDMULTIPLIER : float = 2.0

func initialize(character : Character):
	if character is Player:
		controlled_character = character
	else:
		assert_wrong_character(character, Player)

func on_enter():
	# Check if we are entering this state from a non dashing state.
	# If we entered from dash_attack, we do not want to start dash_timer again.
	if controlled_character.dash_timer.is_stopped():
		controlled_character.dash_timer.start()
		controlled_character.is_dashing = true
		controlled_character.dash_vector = controlled_character.last_direction
		controlled_character.can_dash = false
		controlled_character.start_dash_audio()

func _enter_tree() -> void:
	state_name = "dash"
	state_machine = get_parent()

func input_handle_state(event : InputEvent) -> String:
	if event.is_action_pressed("Melee"):
		return "dash_attack"
		
	return state_name

func process_state(delta : float) -> String:
	if !controlled_character.is_dashing:
		return "idle"
		
	return state_name

func physics_process_state(delta : float) -> String:
	controlled_character.velocity = controlled_character.dash_vector * controlled_character.stats.speed * SPEEDMULTIPLIER
	controlled_character.velocity += controlled_character.direction * controlled_character.stats.speed
	return state_name
