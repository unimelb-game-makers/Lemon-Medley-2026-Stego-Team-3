class_name StatSheet
extends Resource

@export var base_health: int
@export var base_defense: int
@export var base_attack: int
@export var base_speed: int
@export var knockback_speed: float

var health: int
var defense: int
var attack: int
var speed: int

signal death()


## Reset all runtime stats back to their base values.
func reset() -> void:
	health = base_health
	defense = base_defense
	attack = base_attack
	speed = base_speed


## Calculate the amount of damage that we should take based on our
## defense and the incoming attack's attack value.
func damage_calculation(incoming_attack_val: int) -> int:
	var final_damage: int = clamp(incoming_attack_val - defense, 0, INF)
	return final_damage


## Update health value based on incoming attack.
func take_damage(incoming_attack_val: int) -> void:
	var final_damage: int = damage_calculation(incoming_attack_val)
	#print("Taking damage: %s" % final_damage)

	health = clamp(health - final_damage, 0, INF)

	if health == 0:
		death.emit()
