@abstract class_name Character extends CharacterBody2D

## What direction is this character currently facing.
var direction: Vector2 = Vector2.ZERO

## What direction was this character last facing.
var last_direction: Vector2 = Vector2.RIGHT

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
<<<<<<< HEAD
	stats.reset()
	hurt_box.stats = stats
	
=======
	_initialize_hitboxes()
	stats.reset()

## Seperate responsibility of hitbox setup from ready().
## I noticed we like to ovverride a lot, keeping it seperate makes rewriting code easier.
func _initialize_hitboxes() -> void:
>>>>>>> 5a11cf44b342945f4b847a44429d13fd85e98a65
	if touch_damage_box:
		touch_damage_box.set_active(true)
		touch_damage_box.damage = Damage.new(stats.attack)
	
	hurt_box.damage_taken.connect(take_damage)
<<<<<<< HEAD
	#stats.reset()
=======
>>>>>>> 5a11cf44b342945f4b847a44429d13fd85e98a65

## Runs when this character is damaged
@abstract func take_damage(damage : Damage, attack_position : Vector2)

func _process(delta: float) -> void:
	state_machine.process_state(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_process_state(delta)
	move_and_slide()
