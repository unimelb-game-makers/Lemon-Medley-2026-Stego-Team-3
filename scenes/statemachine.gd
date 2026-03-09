extends Node
class_name StateMachine

var state_dict : Dictionary = {}
var active_state : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.controlled_character = get_parent()
			print(child.state_name)
			state_dict[child.state_name] = child
	
	active_state = state_dict["normal"]

func switch_state(newstate : String) -> void:
	if !state_dict.has(newstate):
		print("INVALID STATE %s" % newstate)
	else:
		active_state.on_exit()
		print("CHANGED STATE %s" % newstate)
		active_state = state_dict[newstate]
		active_state.on_enter()

func process_state(delta) -> void:
	active_state.process_state(delta)
