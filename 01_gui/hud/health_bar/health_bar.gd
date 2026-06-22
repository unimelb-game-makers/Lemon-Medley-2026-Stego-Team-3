class_name health_bar extends Control

var temp_value : float
var use_threshold : bool = false

@onready var progress_bar : TextureProgressBar = $Regular
@onready var burst_bar : TextureProgressBar = $Burst

var active = true

func initialise():
	progress_bar.max_value = PlayerManager.player.stats.base_health
	burst_bar.max_value = PlayerManager.player.stats.base_health
	PlayerManager.player.stats.damage_taken.connect(change_health)
	active = true

func _process(delta: float) -> void:
	if not active:
		return
	progress_bar.value = PlayerManager.player.stats.health
	
	if use_threshold:
		if temp_value < PlayerManager.player.stats.health:
			temp_value = clampf(temp_value + 0.05, 0, PlayerManager.player.stats.base_health)
			burst_bar.value = temp_value
			
			if temp_value >= PlayerManager.player.stats.health:
				use_threshold = false
		elif temp_value > PlayerManager.player.stats.health:
			temp_value = clampf(temp_value - 0.05, 0, PlayerManager.player.stats.base_health)
			burst_bar.value = temp_value
			
			if temp_value <= PlayerManager.player.stats.health:
				use_threshold = false

func change_health() -> void:
	if(!use_threshold):
		temp_value = PlayerManager.player.stats.health
		use_threshold = true
