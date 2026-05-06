extends Node
class_name PlayerAudioManager

var player: Player
var tile_map: TileMapLayer
var dash_ability
var distance_traveled: float = 0.0
var footstep_cooldown: float = 0.0
var footstep_min_interval: float = 0.3

@onready var heartbeat_emitter: FmodEventEmitter2D = $HeartbeatEmitter
@onready var dash_emitter: FmodEventEmitter2D = $DashEmitter

func set_controller(controller: Player) -> void:
	player = controller
	tile_map = get_tree().get_first_node_in_group("tile_layer")
	dash_ability = player.dash_ability
	update_heartbeat()
	heartbeat_emitter.set_volume(2.0)
	heartbeat_emitter.play()

func _process(delta: float) -> void:
	if player == null:
		return
	handle_footsteps(delta)
	update_heartbeat()
	
func handle_footsteps(delta: float) -> void:
	footstep_cooldown -= delta
	
	if player.direction != Vector2.ZERO and not dash_ability.is_dashing():
		distance_traveled += player.velocity.length() * delta
		
		if distance_traveled >= 30.0 and footstep_cooldown <= 0.0:
			distance_traveled = 0.0
			footstep_cooldown = footstep_min_interval
			trigger_footstep()
	else:
		distance_traveled = 0.0

func trigger_footstep() -> void:
	var surface = get_surface_type()
	
	var event = FmodServer.create_event_instance("event:/walk")
	event.set_2d_attributes(player.global_transform)
	event.set_parameter_by_name("surface_type", surface)
	event.start()
	event.release()

func get_surface_type() -> float:
	if tile_map == null:
		print("TileMap is null!")
		return 0.0
	var tile_pos = tile_map.local_to_map(tile_map.to_local(player.global_position))
	var tile_data = tile_map.get_cell_tile_data(tile_pos)
	
	if tile_data:
		return tile_data.get_custom_data("surface_type")
	return 0.0

func update_heartbeat() -> void:
	var health_ratio = float(player.stats.health) / float(player.stats.base_health)
	heartbeat_emitter.set_parameter("player_health", health_ratio)
