extends State

## TEMPORARY VARIABLE. WHEN WE HAVE AN ANIMATION WE WILL 
## FINISH ATTACKING AFTER THE ANIMATION ENDS
@export var attack_duration : float

var attacking : bool = false

func _enter_tree() -> void:
	state_name = "attack"
	state_machine = get_parent()

func on_enter():
	attacking = true
	controlled_character.attack_area.activate(attack_duration)
	get_tree().create_timer(attack_duration).timeout.connect(attack_end)

func attack_end():
	attacking = false

func on_exit():
	# Redundancy to ensure that the attack area is deactivated
	controlled_character.attack_area.deactivate()

func process_state(delta : float) -> String:
	if !attacking:
		if controlled_character.direction == Vector2.ZERO:
			return "idle"
	return state_name

func physics_process_state(delta : float) -> String:
	controlled_character.velocity = Vector2.ZERO
	return state_name
