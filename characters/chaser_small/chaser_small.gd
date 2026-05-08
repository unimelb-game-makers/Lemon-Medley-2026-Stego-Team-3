class_name ChaserSmall extends Character

@export var chase_radius : EnrageArea
@export var debug_state_label : Label

func _ready() -> void:
	if touch_damage_box:
		touch_damage_box.set_active(true)
		touch_damage_box.damage = Damage.new(stats.base_attack)

	hurt_box.damage_taken.connect(take_damage)
	stats.death.connect(die)
	stats.reset()

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

func die() -> void:
	print("DYING")
	queue_free()

func take_damage(damage : Damage, attack_position : Vector2):
	stats.take_damage(damage.get_damage_value())
	return
