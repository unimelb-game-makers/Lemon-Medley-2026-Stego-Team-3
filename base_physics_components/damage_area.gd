class_name DamageArea extends Area2D

"""
Layers are not defined because player, enemy, objects, etc
can be on different layers
"""

signal damage_taken(damage : Damage, position : Vector2)

@export var stats : StatSheet

@export var audio: AudioStream # NOTE: This is following tutorial, we can implement differently.

func take_damage(damage : Damage, position : Vector2) -> void:
	print("Health Before Attack: %s" % stats.health)
	damage_taken.emit(damage, position)
	# TODO Play audio through singleton.
	
	# Update stats to take damage
	stats.take_damage(damage.stats.attack * damage.multiplier)
	print("Health After Attack: %s" % stats.health)
	

func make_invulnerable(duration: float = 1.0) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(duration).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
