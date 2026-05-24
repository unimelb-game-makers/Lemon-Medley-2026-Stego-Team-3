@icon("res://characters/00_general_assets/enemy.svg")
class_name RangeEnemy
extends Character

var monster_sound_timer: Timer
@onready var debug_state_label: Label = $DebugStateLabel
@onready var projectile_emitter: ProjectileEmitter = $ProjectileEmitter


#region Lifecycle

func _ready() -> void:
	super._ready()
	setup_projectile_emitter()
	stats.death.connect(_on_death)
	setup_monster_sounds()
	
func setup_monster_sounds() -> void:
	monster_sound_timer = Timer.new()
	add_child(monster_sound_timer)
	monster_sound_timer.timeout.connect(_on_monster_sound_timer)
	monster_sound_timer.start(randf_range(3.0, 8.0))
	
func _on_monster_sound_timer() -> void:
	var event = FmodServer.create_event_instance("event:/monster_sound")
	event.set_2d_attributes(global_transform)
	event.start()
	event.release()
	monster_sound_timer.start(randf_range(3.0, 8.0))
		
func _process(delta: float) -> void:
	state_machine.process_state(delta)

	if state_machine.active_state != null:
		debug_state_label.text = state_machine.active_state.state_name

func _physics_process(delta: float) -> void:
	state_machine.physics_process_state(delta)

	move_and_slide()

	update_direction()

#endregion


#region Setup

func setup_projectile_emitter() -> void:
	print("DAMAGE ", stats.attack)
	projectile_emitter.damage = Damage.new(stats.attack, 1, 0.05, 0)

#endregion


#region Direction

func update_direction() -> void:
	if velocity.x > 0:
		direction.x = 1
	elif velocity.x < 0:
		direction.x = -1

	if velocity.y > 0:
		direction.y = 1
	elif velocity.y < 0:
		direction.y = -1

	direction = direction.normalized()

#endregion


#region Damage

func take_damage(damage: Damage, attack_position: Vector2) -> void:
	stats.take_damage(damage.get_damage_value())
	print("Life: ",stats.health)

func _on_death() -> void:
	queue_free()
	print("range enemy dead")

#endregion
