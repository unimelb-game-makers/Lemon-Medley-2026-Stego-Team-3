extends State

@export var SPEEDMULTIPLIER : float = 2.0

func initialize(character : Character):
	if character is Player:
		controlled_character = character
	else:
		assert_wrong_character(character, Player)

func _enter_tree() -> void:
	state_name = "run"
	state_machine = get_parent()

func input_handle_state(event : InputEvent) -> String:
	if event.is_action_pressed("Melee"):
		return "run_attack"
		
	return state_name

func process_state(delta : float) -> String:
	if !Input.is_action_pressed("Run"):
		return "walk"
	
	if controlled_character.direction == Vector2.ZERO:
		return "idle"
		
	return state_name

func physics_process_state(delta : float) -> String:
	controlled_character.velocity = controlled_character.direction * controlled_character.stats.speed * SPEEDMULTIPLIER
	return state_name
