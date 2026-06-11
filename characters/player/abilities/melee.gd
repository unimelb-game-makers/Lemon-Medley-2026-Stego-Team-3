extends Ability

## TEMPORARY VARIABLE, ONCE WE HAVE ATTACK ANIMATION WE MIGHT NOT USE THIS
@export var ATTACKDURATION : float = 0.5
@export var attack_area : AttackArea
@export var damage: int = 10

var attack_buffered : bool = false
var hit_during_attack: bool = false

func _ready() -> void:
	attack_area.damage = Damage.new(damage)
	attack_area.finished_attack.connect(finish_attack)
	attack_area.hit_enemy.connect(on_hit_enemy)

func activate():
	activated = true
	attack()

func run():
	update_claymore_direction()

## Attack in the direction of our mouse
func attack():
	print("Attacking")
	attack_area.activate(ATTACKDURATION)
	
	hit_during_attack = false
	print("Hit air")
	var event = FmodServer.create_event_instance("event:/sword_swipe_open_air")
	event.set_2d_attributes(controller.global_transform)
	event.start()
	event.release()

func finish_attack():
	activated = false

## Update where our attack is depending on mouse position.
func update_claymore_direction():
	var local_mouse_pos = get_parent().get_parent().get_local_mouse_position()
	attack_area.rotation = local_mouse_pos.angle()

## If we are currently attacking, but are interrupted by something, 
## e.g Enemy attack then cancel early
func cancel_attack():
	attack_buffered = false
	finish_attack()
	attack_area.set_active(false)
	
func on_hit_enemy():
	if not hit_during_attack:
		hit_during_attack = true
		print("Hit enemy")
		var event = FmodServer.create_event_instance("event:/sword_slash_enemy")
		event.set_2d_attributes(controller.global_transform)
		event.start()
		event.release()
