extends Node

var win_scene: PackedScene = preload("res://01_gui/win_screen.tscn")

func win_screen():
	get_tree().change_scene_to_packed(win_scene)
