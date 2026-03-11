class_name DamageArea extends Area2D

"""
Layers are not defined because player, enemy, objects, etc
can be on different layers
"""

signal damage_taken(attack_area)

@export var stats : StatSheet

@export var audio: AudioStream # NOTE: This is following tutorial, we can implement differently.

func take_damage(attack_area: AttackArea) -> void:
	print("Health Before Attack: %s" % stats.health)
	damage_taken.emit(attack_area)
	# TODO Play audio through singleton.
	
	# Update stats to take damage
	stats.take_damage(attack_area.stats.attack)
	print("Health After Attack: %s" % stats.health)
	

func make_invulnerable(duration: float = 1.0) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(duration).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
