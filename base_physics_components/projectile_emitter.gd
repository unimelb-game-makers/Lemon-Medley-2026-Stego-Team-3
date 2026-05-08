class_name ProjectileEmitter
extends Node

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

	projectile_holder.add_child(bullet)
