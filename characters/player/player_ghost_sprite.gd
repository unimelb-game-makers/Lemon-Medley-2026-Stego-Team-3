extends Sprite2D

@export var lifetime: float = 0.7

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start(lifetime)
	var tw: Tween = get_tree().create_tween()
	tw.tween_property(self, "modulate:a", 0, lifetime)

func _on_timer_timeout() -> void:
	queue_free()
