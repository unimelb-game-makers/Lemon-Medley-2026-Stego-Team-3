extends Node 
class_name CurseManager

@export var player_statemachine: StateMachine
@export var curse_state: State

var curse_list: Array[Curse]

func _ready() -> void:
	for child in get_children():
		if child is Curse:
			curse_list.append(child)
