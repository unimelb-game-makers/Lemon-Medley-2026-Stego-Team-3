extends Node 
class_name AbilityManager

@export var stopped: bool = false
@export var player_statemachine: StateMachine
@export var curse_state: State

var abilities: Array[Ability]

func _ready() -> void:
	for child in get_children():
		if child is Ability:
			abilities.append(child)

func _process(delta: float) -> void:
	if stopped:
		return
	for ability: Ability in abilities:
		if Input.is_key_pressed(ability.key) or Input.is_action_pressed(ability.input):
			ability.activate()
