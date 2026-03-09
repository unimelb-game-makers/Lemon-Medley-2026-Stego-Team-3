extends State

var state_machine : StateMachine
@export var SPEEDMULTIPLIER = 2.0

func _enter_tree() -> void:
	state_name = "run"
	state_machine = get_parent()

func on_enter():
	pass

func on_exit():
	pass

func process_state(delta : float):
	var HorizontalAxis = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var VerticalAxis = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	controlled_character.velocity.x = HorizontalAxis * controlled_character.stats.speed * SPEEDMULTIPLIER
	controlled_character.velocity.y = VerticalAxis * controlled_character.stats.speed * SPEEDMULTIPLIER
	
	if !Input.get_action_strength("Run"):
		state_machine.switch_state("normal")
