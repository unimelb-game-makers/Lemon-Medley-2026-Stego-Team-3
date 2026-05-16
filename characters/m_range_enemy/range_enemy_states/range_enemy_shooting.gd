extends State

"""
This state encapsulates its own logic to switch to it
"""

@export var detection_area: VisionArea
@export var target_escaped_state: State
@export var projectile_emitter: ProjectileEmitter

@export var shoot_cooldown: float = 1.0

var target_player: Node2D = null
var shoot_timer: Timer


#region Setup

func setup() -> void:
	if detection_area:
		detection_area.player_entered.connect(_on_player_enter)
		detection_area.player_exited.connect(_on_player_exit)
	
	shoot_timer = Timer.new()
	shoot_timer.one_shot = false
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

	add_child(shoot_timer)

func _enter_tree() -> void:
	state_name = "targetting"
	state_machine = get_parent()

#endregion


#region State

func on_enter() -> void:
	controlled_character.velocity = Vector2.ZERO

func process_state(delta: float) -> String:
	return state_name

#endregion


#region Shooting

func _on_shoot_timer_timeout() -> void:
	if not target_player:
		return

	var direction := (
		target_player.global_position
		- controlled_character.global_position
	).normalized()
	#print("shooting")
	projectile_emitter.shoot(direction)

#endregion


#region Detection

func _on_player_enter() -> void:
	target_player = PlayerManager.player

	state_machine.switch_state(state_name)

	if shoot_timer.is_stopped():
		shoot_timer.start()

func _on_player_exit() -> void:
	target_player = null

	shoot_timer.stop()

	state_machine.switch_state(target_escaped_state.state_name)

#endregion
