class_name EnrageArea extends Area2D

signal player_entered()
signal player_exited()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_entered)
	
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_body_exited)

func _on_body_entered(body : Node2D) -> void:
	if body is Player:
		player_entered.emit()

func _on_body_exited(body : Node2D) -> void:
	if body is Player:
		player_exited.emit()
