class_name Player extends Character

@export var debug_state_label : Label
@export var attack_area : AttackArea

## TEMPORARY VARIABLE, ONCE WE HAVE ATTACK ANIMATION WE MIGHT NOT USE THIS
@export var ATTACKDURATION : float
var attacking : bool = false
var attack_buffered : bool = false

func _ready() -> void:
	PlayerManager.player = self
	
	hurt_box.stats = stats
	attack_area.damage = Damage.new(stats)
	attack_area.finished_attack.connect(finish_attack)
	
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
	print("Attacking")
	attacking = true
	attack_area.activate(ATTACKDURATION)

func finish_attack():
	attacking = false

func take_damage(damage : Damage, attack_position : Vector2):
	last_hit = damage
	last_hit_direction = attack_position.direction_to(global_position)
	
	# For player specifically, we just immediately transition to Stun on getting hit
	# For other enemies, we might want them to only stun from certain states, which is
	# when we decide to fully implement the state transitions. For now this is fine.
	state_machine.switch_state("stun")

## If we are currently attacking, but are interrupted by something, 
## e.g Enemy attack then cancel early
func cancel_attack():
	attack_buffered = false
	finish_attack()
	attack_area.set_active(false)

func _unhandled_input(event : InputEvent) -> void:		
	state_machine.input_handle_state(event)
