extends Node
class_name EnemiesComponent

var enemies: int = 0

signal enemies_cleared

func _ready() -> void:
	for child in get_children():
		if child is Character:
			enemies += 1
			child.killed.connect(check_clear)

func check_clear():
	enemies -= 1
	if enemies <= 0:
		enemies_cleared.emit()
