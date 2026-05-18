extends Node 
class_name AbilityManager

@export var stopped: bool = false
@export var player_statemachine: StateMachine
@export var curse_state: State

var abilities: Array[Ability]

func _ready() -> void:
	for child in get_children():
		if child is Ability:
			abilities.append(child)

func set_controller(controller: Player):
	for ability in abilities:
		ability.controller = controller

func ability_process(delta: float) -> void:
	if stopped: ## If player is stunned or something -> do nothing
		return
	for ability: Ability in abilities:
		# if the ability is not activated and the player presses a key for the ability
		if not ability.activated and (Input.is_key_pressed(ability.key) or (ability.input != "" and Input.is_action_pressed(ability.input))):
			ability.activate()
		# if ability is activated, run the ability each frame
		elif ability.activated:
			ability.run()

## From ability detector
func add_ability(ability: Ability):
	add_child(ability)
	if ability in abilities: # if we already have the ability
		ability.queue_free()
	else:
		abilities.append(ability)
		ability.position = Vector2.ZERO
