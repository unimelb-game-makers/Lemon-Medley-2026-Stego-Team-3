extends Character

@onready var enemy_touch_attack_area: AttackArea = $enemy_touch_attack_area

func take_damage(damage : Damage, attack_position : Vector2):
	print("Dummy taking damage")
	stats.take_damage(damage.get_damage_value())
