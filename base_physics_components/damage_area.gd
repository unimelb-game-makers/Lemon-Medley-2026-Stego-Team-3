class_name DamageArea extends Area2D

"""
Layers are not defined because player, enemy, objects, etc
can be on different layers
"""

signal damage_taken(attack_area)

@export var audio: AudioStream # NOTE: This is following tutorial, we can implement differently.

func take_damage(attack_area: AttackArea) -> void:
	damage_taken.emit(attack_area)
	# Play audio through singleton.

func make_invulnerable(duration: float = 1.0) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(duration).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
