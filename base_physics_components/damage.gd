class_name Damage
extends Resource

@export var multiplier: float = 1.0
@export var damage: int
@export var stun_window: float = 0.5
@export var knockback_strength: float = 1.0


func _init(
	init_damage: int = 0,
	init_multiplier: float = 1.0,
	init_stun_window: float = 0.5,
	init_knockback_strength: float = 1.0
) -> void:
	damage = init_damage
	multiplier = init_multiplier
	stun_window = init_stun_window
	knockback_strength = init_knockback_strength


func get_damage_value() -> int:
	return int(floor(damage * multiplier))


func copy() -> Damage:
	return Damage.new(
		damage,
		multiplier,
		stun_window,
		knockback_strength
	)
