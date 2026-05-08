class_name DamageArea extends Area2D

"""
Layers are not defined because player, enemy, objects, etc
can be on different layers
"""

signal damage_taken(damage : Damage, position : Vector2)

@export var audio: AudioStream # NOTE: This is following tutorial, we can implement differently.

func take_damage(damage_took : Damage, damage_position : Vector2) -> void:
	damage_taken.emit(damage_took, damage_position)
	# TODO Play audio through singleton.

func make_invulnerable(duration: float = 1.0) -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(duration).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
