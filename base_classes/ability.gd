extends Node
class_name Ability

@export var key: Key
@export var input: String

@export var cooldown: float

@onready var cooldown_timer: Timer = $cooldown_timer # Each ability/curse will have a timer for their own cooldown

func activate():
	pass
