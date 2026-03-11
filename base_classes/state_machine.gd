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
	
	if state_dict.has("idle"):
		active_state = state_dict["idle"]
	else:
		assert("ERROR: idle STATE NOT FOUND")

func switch_state(newstate : String) -> void:
	if !state_dict.has(newstate):
		push_error("INVALID STATE %s" % newstate)
	else:
		active_state.on_exit()
		active_state = state_dict[newstate]
		active_state.on_enter()

## Called every frame
func process_state(delta : float) -> void:
	switch_state(active_state.process_state(delta))

## Called every physics process
func physics_process_state(delta : float) -> void:
	switch_state(active_state.physics_process_state(delta))

## Called every unhandled input
func input_handle_state(event : InputEvent) -> void:
	switch_state(active_state.input_handle_state(event))
