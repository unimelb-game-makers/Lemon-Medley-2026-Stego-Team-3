extends Node

const PLAYER = preload("res://characters/player/player_character.tscn")
var player : Player
var player_spawned : bool = false

signal interact_pressed
	
func interact() -> void:
	interact_pressed.emit()
