extends Ability

@export var damage: int = 3
@export var total_time: float = 10
@export var damage_tick: float = 0.5

@onready var damage_ticker: Timer = $damage_ticker ## Deals damage each time it finishes
@onready var runtime_timer: Timer = $runtime_timer ## Times the total ten seconds for which ticks of damage will be dealt
@onready var drain_emitter: FmodEventEmitter2D = $DrainEmitter

var damage_areas: Array[DamageArea]

func _ready() -> void:
	cooldown_timer.wait_time += runtime_timer.wait_time

## Once activated, it will RUN for ten seconds, with each half second dealing damage
func activate():
	if not activated and cooldown_timer.is_stopped():
		activated = true
		damage_ticker.start(damage_tick)
		runtime_timer.start(total_time)
		drain_emitter.play()
		#cooldown_timer.start()

func run():
	if not runtime_timer.is_stopped() and damage_ticker.is_stopped():
		damage_ticker.start(damage_tick)
		queue_redraw()

func _draw() -> void:
	if activated and cooldown_timer.is_stopped():
		draw_circle(Vector2.ZERO, 750, Color.CRIMSON, false, -2)

## When the damage_ticker timer finishes, deal damage
func tick_damage():
	for damage_area in damage_areas:
		damage_area.take_damage(Damage.new(damage), global_position)

func runtime_finished():
	activated = false
	queue_redraw()
	drain_emitter.stop()
	cooldown_timer.start()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is DamageArea and area not in damage_areas:
		damage_areas.append(area)
		print(area.get_parent())

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is DamageArea and area in damage_areas:
		damage_areas.erase(area)
