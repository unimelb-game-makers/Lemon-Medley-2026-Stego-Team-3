extends State

var stun_timer : float = 0.0
var knockback_velocity : Vector2 = Vector2.ZERO
@export var INVULNERABILITYTIMER = 2.0

func initialize(character : Character):
	if character is Player:
		controlled_character = character
	else:
		assert_wrong_character(character, Player)

func _enter_tree() -> void:
	state_name = "stun"
	state_machine = get_parent()

func on_enter() -> void:
	controlled_character.hurt_box.make_invulnerable(INVULNERABILITYTIMER)
	controlled_character.cancel_attack()
	
	knockback_velocity = (controlled_character.last_hit_direction *
						  controlled_character.last_hit.knockback_strength *
						  controlled_character.stats.knockback_speed)
						
	stun_timer = controlled_character.last_hit.stun_window

func on_exit() -> void:
	knockback_velocity = Vector2.ZERO

func process_state(delta : float) -> String:
	stun_timer -= delta
	
	if stun_timer <= 0:
		return "idle"
	
	return state_name

func physics_process_state(delta : float) -> String:
	controlled_character.velocity = knockback_velocity
	return state_name
