@abstract class_name Character extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
@export var stats : StatSheet
@export var state_machine : StateMachine

## The hitbox for this character to take damage
@export var hurt_box : DamageArea

## The hitbox for this character to deal damage to those touching
## Can be empty, i.e touching this does not deal damage
@export var touch_damage_box : AttackArea

func _ready() -> void:
	hurt_box.stats = stats
	
	if touch_damage_box:
		touch_damage_box.set_active(true)
		touch_damage_box.stats = stats
	
	hurt_box.damage_taken.connect(take_damage)
	stats.reset()

## Runs when this character is damaged
@abstract func take_damage(attack_val : AttackArea)

func _process(delta: float) -> void:
	state_machine.process_state(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_process_state(delta)
	move_and_slide()
