@abstract
class_name State
extends Node

var controlled_character : Character
var state_name : String
var state_machine : StateMachine

func initialize(character : Character):
	controlled_character = character

## Call when we expected one Character type but got another
func assert_wrong_character(character : Character, expected):
	assert(true, "ERROR: INVALID CHARACTER OF TYPE %s WHEN EXPECTING %s" % [character.get_class(), expected])

func on_enter():
	pass
	
func on_exit():
	pass
	
func physics_process_state(delta : float) -> String:
	return state_name
	
func process_state(delta : float) -> String:
	return state_name
	
func input_handle_state(event : InputEvent) -> String:
	return state_name
