@icon("res://characters/00_general_assets/enemy.svg")
class_name ChaserSmall extends Character

var monster_sound_timer: Timer
@export var chase_radius : EnrageArea
@export var debug_state_label : Label

func _ready() -> void:
	super._ready()
	stats.death.connect(die)
	monster_sound_timer = Timer.new()
	add_child(monster_sound_timer)
	monster_sound_timer.timeout.connect(_on_chase_sound_timer)

func _process(delta: float) -> void:
	update_direction()
	state_machine.process_state(delta)
	if state_machine.active_state != null:
		debug_state_label.text = state_machine.active_state.state_name

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
	
	if direction != Vector2.ZERO:
		last_direction = direction
	
	# Handle sprite face direction
	anim.flip_h = direction.x >= 0

func die() -> void:
	print("DYING")
	killed.emit()
	queue_free()

func take_damage(damage : Damage, attack_position : Vector2):
	stats.take_damage(damage.get_damage_value())
	return

func play_animation(anim: String):
	pass
	
func start_chase_sound() -> void:
	monster_sound_timer.start(randf_range(2.0, 5.0))
	
func stop_chase_sound() -> void:
	monster_sound_timer.stop()
	
func _on_chase_sound_timer() -> void:
	var event = FmodServer.create_event_instance("event:/metal_hit_on_floor")
	event.set_2d_attributes(global_transform)
	event.start()
	event.release()
	monster_sound_timer.start(randf_range(2.0, 5.0))
