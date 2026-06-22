extends CanvasLayer

var is_paused : bool = false
@onready var pause_screen = $PauseScreen
@onready var game_over_screen = $GameOverScreen
@onready var cooldown_timers = $CooldownTimers
const COOLDOWN_TIMER = preload("res://01_gui/hud/timer_cooldowns/timer_cooldown.tscn")
var can_pause : bool = true
var is_dead : bool = false

func toggle_pause():
	if !can_pause:
		return
	
	if is_paused:
		pause_screen.visible = false
		get_tree().paused = false
	elif !is_paused:
		pause_screen.visible = true
		get_tree().paused = true
	is_paused = !is_paused

func on_death():
	can_pause = false
	PlayerManager.player.set_process_unhandled_input(false)
	PlayerManager.player.hurt_box.monitorable = false
	await get_tree().create_timer(2).timeout
	get_tree().paused = true
	game_over_screen.visible = true

func retry():
	game_over_screen.visible = false
	LevelManager.retry_level()
	PlayerManager.player.velocity = Vector2.ZERO
	get_tree().paused = false
	
	can_pause = true
	PlayerManager.player.hurt_box.make_invulnerable(2.0)
	PlayerManager.player.hurt_box.monitorable = true

func attach_cooldowns():
	for ability in PlayerManager.player.ability_manager.abilities:
		if ability.cooldown_timer != null:
			var timer = COOLDOWN_TIMER.instantiate()
			cooldown_timers.add_child(timer)
			timer.attach(ability)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		toggle_pause()
