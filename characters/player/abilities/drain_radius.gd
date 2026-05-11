extends Ability

@export var total_time: float = 10
@export var damage_tick: float = 0.5

@onready var damage_ticker: Timer = $damage_ticker ## Deals damage each time it finishes
@onready var runtime_timer: Timer = $runtime_timer ## Times the total ten seconds for which ticks of damage will be dealt

## Once activated, it will RUN for ten seconds, with each half second dealing damage
func activate():
	if not activated and cooldown_timer.is_stopped():
		activated = true
		damage_ticker.start(damage_tick)
		runtime_timer.start(total_time)

func run():
	if not runtime_timer.is_stopped() and damage_ticker.is_stopped():
		damage_ticker.start(damage_tick)
		queue_redraw()

func _draw() -> void:
	if activated and cooldown_timer.is_stopped():
		draw_circle(Vector2.ZERO, 750, Color.CRIMSON, false, -2)

## When the damage_ticker timer finishes, deal damage
func tick_damage():
	print("damage")

func runtime_finished():
	activated = false
	cooldown_timer.start(cooldown)
	queue_redraw()
