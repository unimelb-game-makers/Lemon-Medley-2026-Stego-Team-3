class_name AttackArea extends Area2D

"""
Layers are not defined because player, enemy, objects, etc
can be on different layers
"""

signal finished_attack

@export var damage : Damage
var semaphore : int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_entered)
	visible = false
	monitorable = false
	monitoring = false

func _on_body_entered(body: Node2D) -> void:
	if body is DamageArea:
		body.take_damage(damage, global_position)

func activate(duration: float = 0.1) -> void:
	# Uses semaphore to detect if interrupted and another process begins before
	# initial timer is finished. 
	
	semaphore += 1
	set_active()
	await get_tree().create_timer(duration).timeout
	semaphore -= 1
	
	if semaphore == 0:
		set_active(false)
		finished_attack.emit()


func set_active(value: bool = true) -> void:
	monitoring = value
	visible = value


## WARNING: To be fixed for when top-down is implemented
func flip(direction_x: float) -> void:
	if direction_x > 0:
		scale.x = 1
	elif direction_x < 0:
		scale.x = -1
