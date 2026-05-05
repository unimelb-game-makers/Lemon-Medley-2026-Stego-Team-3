class_name Player extends Character

@export var debug_state_label : Label
@export var debug_dash_label : Label

@onready var ability_manager: AbilityManager = $ability_manager

# Audio related variables
var distance_traveled: float = 0.0
var footstep_cooldown: float = 0.0
var footstep_min_interval: float = 0.3
@onready var heartbeat_emitter: FmodEventEmitter2D = $HeartbeatEmitter
@onready var tile_map: TileMapLayer
@onready var dash_emitter: FmodEventEmitter2D = $DashEmitter
@onready var dash_ability = $ability_manager/dash

func _ready() -> void:
	PlayerManager.player = self
	hurt_box.stats = stats
	hurt_box.damage_taken.connect(take_damage)
	stats.reset()
	ability_manager.set_controller(self)
	update_heartbeat()
	heartbeat_emitter.set_volume(2.0)
	heartbeat_emitter.play()

func _process(delta: float) -> void:
	#debug_state_label.text = state_machine.active_state.state_name
	#debug_dash_label.text = "Can Dash" if can_dash else "Cannot Dash"
	update_direction()
	
	state_machine.process_state(delta)
	handle_footsteps(delta)
	update_heartbeat()

func _physics_process(delta: float) -> void:
	state_machine.physics_process_state(delta)
	ability_manager.ability_process(delta)
	move_and_slide()

func update_direction() -> void:
	var HorizontalAxis = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var VerticalAxis = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	direction = Vector2(HorizontalAxis, VerticalAxis).normalized()
	
	if direction != Vector2.ZERO:
		last_direction = direction

func take_damage(damage : Damage, attack_position : Vector2):
	last_hit = damage
	last_hit_direction = attack_position.direction_to(global_position)
	
	# For player specifically, we just immediately transition to Stun on getting hit
	# For other enemies, we might want them to only stun from certain states, which is
	# when we decide to fully implement the state transitions. For now this is fine.
	state_machine.switch_state("stun")

## Stop all abilities. Pause processing input for them.
func stop_abilities():
	ability_manager.stopped = true

func continue_abilities():
	ability_manager.stopped = false

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("test"):
		PlayerManager.shake_camera()
		return
	
	state_machine.input_handle_state(event)


# audio related funcs below
func handle_footsteps(delta: float) -> void:
	footstep_cooldown -= delta
	
	if direction != Vector2.ZERO and not dash_ability.is_dashing():
		distance_traveled += velocity.length() * delta
		
		if distance_traveled >= 30.0 and footstep_cooldown <= 0.0:
			distance_traveled = 0.0
			footstep_cooldown = footstep_min_interval
			trigger_footstep()
	else:
		distance_traveled = 0.0


func trigger_footstep() -> void:
	var surface = get_surface_type()
	
	var event = FmodServer.create_event_instance("event:/walk")
	event.set_2d_attributes(global_transform)
	event.set_parameter_by_name("surface_type", surface)
	event.start()
	event.release()
	
func get_surface_type() -> float:
	if tile_map == null:
		print("TileMap is null!")
		return 0.0
	var tile_pos = tile_map.local_to_map(tile_map.to_local(global_position))
	var tile_data = tile_map.get_cell_tile_data(tile_pos)
	
	if tile_data:
		return tile_data.get_custom_data("surface_type")
	return 0.0
	
func update_heartbeat() -> void:
	var health_ratio = float(stats.health) / float(stats.base_health)
	heartbeat_emitter.set_parameter("player_health", health_ratio)
