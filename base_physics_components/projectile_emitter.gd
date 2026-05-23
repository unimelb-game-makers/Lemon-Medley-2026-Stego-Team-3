class_name ProjectileEmitter
extends Node2D

@export var projectile_scene: PackedScene
@export var projectile_holder: Node

var damage: Damage


func shoot(direction: Vector2) -> void:
	var bullet := projectile_scene.instantiate() as Projectile

	if bullet == null:
		push_error("Projectile scene must have a root script that extends Projectile.")
		return

	bullet.direction = direction.normalized()

	if damage != null:
		bullet.damage = damage.copy()
	else:
		push_error("ProjectileEmitter has no Damage assigned.")
		bullet.damage = null

	if projectile_holder:
		projectile_holder.add_child(bullet)
	else:
		get_tree().current_scene.add_child(bullet)

	bullet.global_position = global_position
	
	var event = FmodServer.create_event_instance("event:/enemy_shooting")
	event.set_2d_attributes(global_transform)
	event.start()
	event.release()
