extends Node
class_name Curse

@export var control: Key
@export var cooldown: float

@onready var timer: Timer = $Timer # Each curse will have a timer for their own cooldown

func activate_curse():
	pass
