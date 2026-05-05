extends Ability

@export var SPEEDMULTIPLIER : float = 2.0

@onready var dash_timer : Timer = $dash_timer

var dash_vector : Vector2

func _ready() -> void:
	dash_timer.timeout.connect(stop_dash)

func activate():
	if dash_timer.is_stopped() and cooldown_timer.is_stopped():
		activated = true
		dash_timer.start()
		dash_vector = controller.last_direction

func run():
	controller.velocity = dash_vector * controller.stats.speed * SPEEDMULTIPLIER
	controller.velocity += controller.direction * controller.stats.speed
	print("dash")

func stop_dash():
	activated = false
	cooldown_timer.start(cooldown)
