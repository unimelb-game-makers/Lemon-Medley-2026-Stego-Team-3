extends Projectile

@export var speed: float = 20.0


func _ready() -> void:
	super._ready()
	_update_rotation_to_direction()


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func _update_rotation_to_direction() -> void:
	if direction == Vector2.ZERO:
		return

	rotation = direction.angle()


func _on_collision_box_area_entered(area: Area2D) -> void:
	despawn()
