extends Ability

# Dash related variables
@export var dash_timer : Timer
var is_dashing : bool = false
var can_dash : bool = true
var dash_vector : Vector2

func _ready() -> void:
	cooldown_timer.timeout.connect(func(): can_dash = true)
	dash_timer.timeout.connect(stop_dash)

func activate():
	print("Dash")

func stop_dash():
	if !dash_timer.is_stopped():
		dash_timer.stop()
		
	if is_dashing:
		is_dashing = false
		cooldown_timer.start()
