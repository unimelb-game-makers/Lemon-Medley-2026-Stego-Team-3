extends State

@export var walk_pop_duration: float = 0.09

@onready var pop_timer: Timer = $walk_timer

var can_pop: bool = true

func initialize(character : Character):
	if character is Player:
		controlled_character = character
	else:
		assert_wrong_character(character, Player)

func _enter_tree() -> void:
	state_name = "walk"
	state_machine = get_parent()

func physics_process_state(delta : float):
	controlled_character.velocity = controlled_character.direction * controlled_character.stats.speed
	#print("walk")
	return state_name

func input_handle_state(event : InputEvent):
	if event.is_action_pressed("Interact"):
		PlayerManager.interact()
	return state_name

func process_state(delta : float):
	if controlled_character.direction == Vector2.ZERO:
		return "idle"
	if pop_timer.is_stopped() and can_pop:
		pop_timer.start(walk_pop_duration)
		var tw1: Tween = get_tree().create_tween()
		tw1.tween_property(controlled_character.sprite, "scale:y", 0.08, walk_pop_duration/2)
		tw1.tween_property(controlled_character.sprite, "scale:y", 0.1, walk_pop_duration/2)
	return state_name

func dash_started():
	can_pop = false

func dash_ended():
	can_pop = true
