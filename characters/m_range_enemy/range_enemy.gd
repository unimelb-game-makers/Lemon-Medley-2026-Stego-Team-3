@icon("res://characters/00_general_assets/enemy.svg")
class_name RangeEnemy
extends Character

@onready var debug_state_label: Label = $DebugStateLabel
@onready var projectile_emitter: ProjectileEmitter = $ProjectileEmitter


#region Lifecycle

func _ready() -> void:
	super._ready()
	setup_projectile_emitter()

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
	return

func _on_death() -> void:
	pass

#endregion
