class_name Player extends Character

@export var debug_state_label : Label
@export var debug_dash_label : Label

@onready var ability_manager: AbilityManager = $ability_manager
@onready var audio_manager: PlayerAudioManager = $player_audio_manager
@onready var dash_ability = $ability_manager/dash
@onready var ability_detector: AbilityDetector = $ability_detector

func _ready() -> void:
	PlayerManager.player = self
	hurt_box.damage_taken.connect(take_damage)
	stats.reset()
	ability_manager.set_controller(self)
	audio_manager.set_controller(self)

func _process(delta: float) -> void:
	#debug_state_label.text = state_machine.active_state.state_name
	#debug_dash_label.text = "Can Dash" if can_dash else "Cannot Dash"
	update_direction()
	
	state_machine.process_state(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_process_state(delta)
	ability_manager.ability_process(delta)
	move_and_slide()

func update_direction() -> void:
	var HorizontalAxis = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var VerticalAxis = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	direction = Vector2(HorizontalAxis, VerticalAxis).normalized()
	
	if direction != Vector2.ZERO:
		last_direction = direction

func take_damage(damage : Damage, attack_position : Vector2):
	last_hit = damage
	last_hit_direction = attack_position.direction_to(global_position)
	stats.take_damage(damage.get_damage_value())
	# For player specifically, we just immediately transition to Stun on getting hit
	# For other enemies, we might want them to only stun from certain states, which is
	# when we decide to fully implement the state transitions. For now this is fine.
	state_machine.switch_state("stun")

## Stop all abilities. Pause processing input for them.
func stop_abilities():
	ability_manager.stopped = true

func continue_abilities():
	ability_manager.stopped = false

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("test"):
		PlayerManager.shake_camera()
		return
	
	state_machine.input_handle_state(event)
	ability_detector.input_handling(event) # handle when the player meets a new ability pickup
