extends Character

@export var debug_state_label : Label
@export var attack_area : AttackArea

## TEMPORARY VARIABLE, ONCE WE HAVE ATTACK ANIMATION WE WILL NOT USE THIS
@export var ATTACKDURATION : float

func _ready() -> void:
	hurt_box.stats = stats
	attack_area.stats = stats
	
	if touch_damage_box:
		touch_damage_box.stats = stats
	
	hurt_box.damage_taken.connect(take_damage)
	stats.reset()

func _process(delta: float) -> void:
	debug_state_label.text = state_machine.active_state.state_name
	update_direction()
	update_claymore_direction()
	state_machine.process_state(delta)

## Update where our attack is depending on mouse position.
func update_claymore_direction():
	var mouse_global_position = get_global_mouse_position()
	attack_area.rotation = global_position.angle_to(mouse_global_position)

func update_direction() -> void:
	var HorizontalAxis = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var VerticalAxis = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	direction = Vector2(HorizontalAxis, VerticalAxis).normalized()

## Attack in the direction of our mouse
func attack():
	attack_area.activate(ATTACKDURATION)

func take_damage(attack_val : AttackArea):
	cancel_attack()

## If we are currently attacking, but are interrupted by something, 
## e.g Enemy attack then cancel early
func cancel_attack():
	attack_area.set_active(false)

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("Melee"):
		attack()
		
	state_machine.input_handle_state(event)
