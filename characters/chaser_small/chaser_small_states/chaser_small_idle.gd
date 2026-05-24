extends State

var chase = false

func _enter_tree() -> void:
	state_name = "idle"
	state_machine = get_parent()

func on_enter() -> void:
	controlled_character.velocity = Vector2.ZERO
	chase = false
	controlled_character.chase_radius.player_entered.connect(enter_chase)
	controlled_character.anim.play("idle")

func on_exit() -> void:
	chase = false
	controlled_character.chase_radius.player_entered.disconnect(enter_chase)

func enter_chase() -> void:
	chase = true

func process_state(delta : float) -> String:
	if chase:
		return "chase"
	return state_name
