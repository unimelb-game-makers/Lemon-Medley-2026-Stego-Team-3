class_name StatSheet
extends Resource
@export var base_health : int
@export var base_defense : int
@export var base_attack : int
@export var base_speed : int

@export var health : int
@export var defense : int
@export var attack : int
@export var speed : int

func reset() -> void:
	health = base_health
	defense = base_defense
	attack = base_attack
	speed = base_speed
