extends State

"""
This state encapsulates its own logic to switch to it
"""

@export var detection_area: VisionArea
@export var target_escaped_state: State
@export var projectile_emitter: ProjectileEmitter

@export var shoot_cooldown: float = 1.0

@export_category("Chasing and Kiting")
@export var kite_range: float = 500.0
@export var kite_variance: float = 0.35
@export var direction_change_rate: float = 1.0
@export var CHASE_SPEED_MUTLIPLIER: float = 1.0

var target_player: Node2D = null
var shoot_timer: Timer
var chase_timer: Timer


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

	chase_timer = Timer.new()
	chase_timer.one_shot = false
	chase_timer.wait_time = direction_change_rate
	chase_timer.timeout.connect(_on_chase_timer_timeout)
	add_child(chase_timer)


func _enter_tree() -> void:
	state_name = "targetting"
	state_machine = get_parent()

#endregion


#region State

func on_enter() -> void:
	controlled_character.velocity = Vector2.ZERO
	
	if target_player:
		_update_chase_velocity()
		
		if chase_timer.is_stopped():
			chase_timer.start()


func process_state(delta: float) -> String:
	return state_name


func physics_process_state(delta: float) -> String:
	if !target_player:
		controlled_character.velocity = Vector2.ZERO
		
		if chase_timer and !chase_timer.is_stopped():
			chase_timer.stop()
		
		return target_escaped_state.state_name

	return state_name

#endregion


#region Shooting and Moving

func _update_chase_velocity() -> void:
	if !target_player:
		controlled_character.velocity = Vector2.ZERO
		return

	var current_position: Vector2 = controlled_character.global_position
	var target_position: Vector2 = target_player.global_position

	var distance_to_target: float = current_position.distance_to(target_position)
	var direction_to_target: Vector2 = current_position.direction_to(target_position)

	var movement_direction: Vector2 = Vector2.ZERO

	if distance_to_target > kite_range:
		# Too far away, move toward the player.
		movement_direction = direction_to_target
	elif distance_to_target < kite_range:
		# Too close, move away from the player.
		movement_direction = -direction_to_target
	else:
		# Exactly at the desired kite range.
		movement_direction = Vector2.ZERO

	if movement_direction != Vector2.ZERO:
		var random_angle: float = randf_range(-kite_variance, kite_variance)
		movement_direction = movement_direction.rotated(random_angle).normalized()

	controlled_character.velocity = movement_direction * controlled_character.stats.speed * CHASE_SPEED_MUTLIPLIER


func _on_chase_timer_timeout() -> void:
	_update_chase_velocity()


func _on_shoot_timer_timeout() -> void:
	if not target_player:
		return

	var direction := (
		target_player.global_position
		- controlled_character.global_position
	).normalized()

	projectile_emitter.shoot(direction)

#endregion


#region Detection

func _on_player_enter() -> void:
	target_player = PlayerManager.player

	state_machine.switch_state(state_name)

	_update_chase_velocity()

	if shoot_timer.is_stopped():
		shoot_timer.start()
	
	if chase_timer.is_stopped():
		chase_timer.start()


func _on_player_exit() -> void:
	target_player = null

	controlled_character.velocity = Vector2.ZERO

	shoot_timer.stop()
	chase_timer.stop()

	state_machine.switch_state(target_escaped_state.state_name)

#endregion
