extends State

@export var navigation_agent : NavigationAgent2D
@export var CHASE_SPEED_MUTLIPLIER = 1.2
@export var forget_timer : Timer

var is_chasing = false

func _enter_tree() -> void:
	state_name = "chase"
	state_machine = get_parent()

func on_enter() -> void:
	is_chasing = true
	controlled_character.chase_radius.player_exited.connect(start_forget_timer)
	forget_timer.timeout.connect(stop_chase)
	controlled_character.start_chase_sound()

func on_exit() -> void:
	is_chasing = false
	controlled_character.chase_radius.player_exited.disconnect(start_forget_timer)
	forget_timer.timeout.disconnect(stop_chase)
	controlled_character.stop_chase_sound()

## When the player is out of radius from the enemy, 
## The enemy will continue to chase, but after some time will return to idle
func start_forget_timer() -> void:
	if forget_timer.is_inside_tree():
		forget_timer.start()

func stop_chase() -> void:
	is_chasing = false

func physics_process_state(delta : float) -> String:
	navigation_agent.target_position = PlayerManager.player.global_position
	
	if navigation_agent.is_navigation_finished():
		return state_name
	
	var current_position = controlled_character.global_position
	var next_position = navigation_agent.get_next_path_position()
	var next_velocity = current_position.direction_to(next_position) * controlled_character.stats.speed * CHASE_SPEED_MUTLIPLIER
	
	controlled_character.velocity = next_velocity
	
	return state_name

func process_state(delta : float) -> String:
	if !is_chasing:
		return "idle"
	return state_name
