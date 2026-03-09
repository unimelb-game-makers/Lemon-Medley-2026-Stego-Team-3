class_name AttackArea extends Area2D

"""
Layers are not defined because player, enemy, objects, etc
can be on different layers
"""

@export var damage: float = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_entered)
	visible = false
	monitorable = false
	monitoring = false

func _on_body_entered(body: Node2D) -> void:
	if body is DamageArea:
		body.take_damage(self)


func activate(duration: float = 0.1) -> void:
	set_active()
	await get_tree().create_timer(duration).timeout
	set_active(false)


func set_active(value: bool = true) -> void:
	monitoring = value
	visible = value


## WARNING: To be fixed for when top-down is implemented
func flip(direction_x: float) -> void:
	if direction_x > 0:
		scale.x = 1
	elif direction_x < 0:
		scale.x = -1
