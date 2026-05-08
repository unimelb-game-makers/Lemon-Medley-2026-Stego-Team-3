class_name Projectile
extends Node2D

@export var attack_area: AttackArea
@export var disappear_time: float = 999.0
@export var collision_despawn_delay: float = 0.05

var direction: Vector2 = Vector2.ZERO
var damage: Damage

var _despawn_timer: Timer
var _is_despawning: bool = false


func _ready() -> void:
	_setup_attack_area()
	_start_despawn_timer()


func _setup_attack_area() -> void:
	if attack_area == null:
		return

	attack_area.damage = damage
	attack_area.set_active()

	_connect_attack_area_signals()


func _connect_attack_area_signals() -> void:
	if attack_area.area_entered.is_connected(_on_attack_area_area_entered):
		return

	attack_area.area_entered.connect(_on_attack_area_area_entered)


func _on_attack_area_area_entered(area: Area2D) -> void:
	despawn_after_collision_delay()


func _start_despawn_timer() -> void:
	if disappear_time <= 0.0:
		return

	_despawn_timer = Timer.new()
	_despawn_timer.one_shot = true
	_despawn_timer.wait_time = disappear_time
	_despawn_timer.timeout.connect(despawn)

	add_child(_despawn_timer)
	_despawn_timer.start()


func despawn() -> void:
	if _is_despawning:
		return

	_is_despawning = true
	queue_free()


func despawn_after_collision_delay() -> void:
	if _is_despawning:
		return

	_is_despawning = true

	if collision_despawn_delay <= 0.0:
		queue_free()
		return

	await get_tree().create_timer(collision_despawn_delay).timeout
	queue_free()
