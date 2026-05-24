extends Ability

@export var dash_duration: float = 0.5
@export var SPEEDMULTIPLIER : float = 5
@export var ghost_sprite: PackedScene

@onready var dash_timer : Timer = $dash_timer
@onready var ghost_spawn_timer: Timer = $ghost_spawn_timer

var dash_vector : Vector2

signal dash_started
signal dash_ended

func _ready() -> void:
	cooldown_timer.wait_time = dash_timer.wait_time + cooldown_timer.wait_time
	dash_timer.timeout.connect(stop_dash)

func activate():
	if dash_timer.is_stopped() and cooldown_timer.is_stopped():
		activated = true
		dash_started.emit()
		dash_timer.start(dash_duration)
		dash_vector = controller.last_direction
		controller.audio_manager.dash_emitter.play() 
		var tw1: Tween = get_tree().create_tween()
		tw1.tween_property(controller.sprite, "scale:y", 0.05, 0.1)

func run():
	controller.velocity = dash_vector * controller.stats.speed * SPEEDMULTIPLIER
	controller.velocity += controller.direction * controller.stats.speed
	if ghost_spawn_timer.is_stopped():
		ghost_spawn_timer.start()
	print("dash")

func stop_dash():
	activated = false
	controller.audio_manager.dash_emitter.stop()
	var tw1: Tween = get_tree().create_tween()
	tw1.tween_property(controller.sprite, "scale:y", 0.1, 0.1)
	dash_ended.emit()

func is_dashing() -> bool:
	return activated

func _on_ghost_spawn_timer_timeout() -> void:
	var ghost: Sprite2D = ghost_sprite.instantiate()
	get_parent().get_parent().get_parent().add_child(ghost)
	ghost.global_position = controller.sprite.global_position
	ghost.texture = controller.sprite.texture
	ghost.global_transform = controller.sprite.global_transform
	ghost.offset = controller.sprite.offset
