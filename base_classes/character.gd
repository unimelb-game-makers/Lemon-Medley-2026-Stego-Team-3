class_name Character extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
@export var stats : StatSheet
@export var state_machine : StateMachine
@export var hurt_box : DamageArea
@export var attack_area : AttackArea

func _ready() -> void:
	hurt_box.damage_taken.connect(stats.take_damage)
	stats.reset()

func _process(delta: float) -> void:
	state_machine.process_state(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_process_state(delta)
	move_and_slide()
