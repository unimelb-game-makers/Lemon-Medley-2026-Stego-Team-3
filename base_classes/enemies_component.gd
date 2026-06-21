extends Node
class_name EnemiesComponent

@export var debug: bool = false

var enemies: int = 0

signal enemies_cleared

func _ready() -> void:
	for child in get_children():
		if child is Character:
			enemies += 1
			child.killed.connect(check_clear)

func _input(event: InputEvent) -> void:
	if debug and Input.is_action_just_pressed("Dash"): ## Test to kill all enemies
		enemies = 0
		check_clear()

func check_clear():
	enemies -= 1
	if enemies <= 0:
		enemies_cleared.emit()
