extends Character

@export var debug_state_label : Label

func _process(delta: float) -> void:
	debug_state_label.text = state_machine.active_state.state_name
	update_direction()
	update_claymore_direction()
	state_machine.process_state(delta)

func update_claymore_direction():
	var mouse_global_position = get_global_mouse_position()
	attack_area.rotation = global_position.angle_to(mouse_global_position)

func update_direction() -> void:
	var HorizontalAxis = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var VerticalAxis = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	direction = Vector2(HorizontalAxis, VerticalAxis).normalized()

func _unhandled_input(event : InputEvent) -> void:
	state_machine.input_handle_state(event)
