extends Ability

## TEMPORARY VARIABLE, ONCE WE HAVE ATTACK ANIMATION WE MIGHT NOT USE THIS
@export var ATTACKDURATION : float = 0.5
@export var attack_area : AttackArea
@export var damage: int
var attacking : bool = false
var attack_buffered : bool = false

func _ready() -> void:
	attack_area.damage = Damage.new(damage)
	attack_area.finished_attack.connect(finish_attack)

func activate():
	update_claymore_direction()
	print("Melee")

## Attack in the direction of our mouse
func attack():
	print("Attacking")
	attacking = true
	attack_area.activate(ATTACKDURATION)

func finish_attack():
	attacking = false

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
