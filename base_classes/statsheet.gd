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

signal death()

## Reset all stats back to default values
func reset() -> void:
	health = base_health
	defense = base_defense
	attack = base_attack
	speed = base_speed

## Calculate the amount of damage that we should take based on our 
## defense and the incoming attack's attack value.
func damage_calculation(incoming_attack_val : int):
	# Simplified damage calculation. Will probably change later
	var final_damage = incoming_attack_val - defense
	return final_damage

## Update health value based on incoming attack
func take_damage(incoming_attack_val : int):
	var final_damage = damage_calculation(incoming_attack_val)
	print("Taking damage: %s" % final_damage)
	health = clamp(health - final_damage, 0, INF)
	
	if health == 0:
		death.emit()
