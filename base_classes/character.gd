@abstract class_name Character extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
@export var stats : StatSheet
@export var state_machine : StateMachine

## The hitbox for this character to take damage
@export var hurt_box : DamageArea

## The hitbox for this character to deal damage to those touching
## Can be empty, i.e touching this does not deal damage
@export var touch_damage_box : AttackArea

## What were the stats of the attack that hit us
var last_hit : Damage

## Direction vector of the last attack that hit us to calculate knockback
var last_hit_direction : Vector2

func _ready() -> void:
	hurt_box.stats = stats
	
	if touch_damage_box:
		touch_damage_box.set_active(true)
		touch_damage_box.damage = Damage.new(stats)
	
	hurt_box.damage_taken.connect(take_damage)
	stats.reset()

## Runs when this character is damaged
@abstract func take_damage(damage : Damage, attack_position : Vector2)

func _process(delta: float) -> void:
	state_machine.process_state(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_process_state(delta)
	move_and_slide()
