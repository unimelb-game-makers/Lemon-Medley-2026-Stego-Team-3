class_name Damage extends Resource

@export var multiplier : float = 1.0
@export var stats : StatSheet
@export var stun_window : float = 0.5
@export var knockback_strength : float = 1.0

func _init(stats : StatSheet, multiplier : float = 1.0, stun_window : float = 0.5, knockback_strength : float = 1.0):
	self.multiplier = multiplier
	self.stats = stats
	self.stun_window = stun_window
	self.knockback_strength = knockback_strength
