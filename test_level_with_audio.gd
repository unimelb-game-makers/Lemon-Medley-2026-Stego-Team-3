extends Node2D

var player = null
var combat_radius: float = 300.0
var linger_time: float = 5.0
var transition_speed_in: float = 1.3
var transition_speed_out: float = 0.1 
var current_intensity: float = 0.0
var linger_timer: float = 0.0
var in_combat: bool = false

@onready var level_music_emitter: FmodEventEmitter2D = $LevelMusicEmitter
@onready var dummy = $TestDummy

func _ready() -> void:
	while PlayerManager.player == null:
		await get_tree().process_frame
	
	player = PlayerManager.player
	update_player_health()
	level_music_emitter.play()
	#level_music_emitter.set_volume(0.2);

func _process(delta: float) -> void:
	update_combat_intensity(delta)
	update_player_health()

func update_combat_intensity(delta:float) -> void:
	if dummy == null or player == null:
		return
	
	var distance = player.global_position.distance_to(dummy.global_position)
	
	if distance <= combat_radius:
		in_combat = true
		linger_timer = linger_time
	else:
		if in_combat:
			linger_timer -= delta
			if linger_timer <= 0.0:
				in_combat = false
				
	var target_intensity = 1.0 if in_combat else 0.0
	var speed = transition_speed_in if target_intensity == 1.0 else transition_speed_out
	current_intensity = lerp(current_intensity, target_intensity, speed * delta)
	level_music_emitter.set_parameter("combat_intensity", current_intensity)

func update_player_health() -> void:
	var health_ratio = float(player.stats.health) / float(player.stats.base_health)
	level_music_emitter.set_parameter("player_health", health_ratio)
	
  
