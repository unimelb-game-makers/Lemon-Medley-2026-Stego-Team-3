extends CharacterBody2D

@export var stats : StatSheet
@export var state_machine : StateMachine

func _ready() -> void:
	stats.reset()

func _physics_process(delta: float) -> void:
	state_machine.process_state(delta)
	move_and_slide()
	pass
