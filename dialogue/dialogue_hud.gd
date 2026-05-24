@tool
class_name DialogueHUD extends CanvasLayer

@export var dialogue_text : RichTextLabel
@export var name_text : RichTextLabel
@export var is_active : bool = false
@export var choice_container : VBoxContainer
@export var choice_panel_container : Control
var dialogue_started: bool = false
var dialogue_finished : bool = false
var current_dialogue : Dialogue = null
var semaphore : int = 0

func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child(self)
			return
		return
	
	visible = is_active
	pass

func start_dialogue(dialogue : Dialogue) -> void:
	print("Starting Start Dialogue")
	PlayerManager.player.state_machine.switch_state("dialogue")
	show_dialogue(dialogue)
	
	if not dialogue_started:
		dialogue_started = true
		var event = FmodServer.create_event_instance("event:/interactive_harp")
		event.start()
		event.release()

## Used to show simple dialogues with no branches, checks, etc.
func show_simple_dialogue(dialogue : Dialogue) -> void:
	visible = true
	current_dialogue = dialogue
	choice_container.visible = false
	choice_panel_container.visible = false
	
	dialogue_text.text = current_dialogue.dialogue_text
	name_text.text = current_dialogue.character_resource.character_name
	
	# Using the semaphore condition again to stop a bug where players, interacting
	# with the same dialogue really fast can set is_active to true after its been closed.
	semaphore = 1
	
	# Wait first so that the Interact input does not get handled twice
	await get_tree().process_frame
	await get_tree().process_frame
	
	semaphore -= 1
	if semaphore == 0:
		is_active = true

## Used to show dialogues with choices
func show_dialogue_choice(dialogue : Dialogue) -> void:
	visible = true
	current_dialogue = dialogue
	
	dialogue_text.text = current_dialogue.dialogue_text
	name_text.text = current_dialogue.character_resource.character_name
	
	# Clear all options.
	for option in choice_container.get_children():
		option.queue_free()
	
	for i in range(dialogue.dialogue_options.size()):
		var button = Button.new()
		button.text = dialogue.dialogue_options[i]
		button.pressed.connect(func():
				var sfx = FmodServer.create_event_instance("event:/UI_sfx_1")
				sfx.start()
				sfx.release()
				start_dialogue(dialogue.possible_next_dialogues[i]))
		choice_container.add_child(button)
	
	choice_panel_container.visible = true
	choice_container.visible = true

func show_dialogue(dialogue : Dialogue) -> void:
	if dialogue is DialogueChoice:
		show_dialogue_choice(dialogue)
	else:
		show_simple_dialogue(dialogue)

func end_dialogue() -> void:
	semaphore -= 1
	is_active = false
	visible = false
	dialogue_started = false
	
	dialogue_text.text = ""
	name_text.text = ""
	current_dialogue = null
	
	# Awaits a little to avoid double handling
	await get_tree().process_frame
	await get_tree().process_frame
	
	PlayerManager.player.state_machine.switch_state("idle")

func _unhandled_input(event: InputEvent) -> void:
	if !is_active:
		return 
	
	if current_dialogue is DialogueChoice:
		return
	
	if Input.is_action_pressed("Interact"):
		
		var sfx = FmodServer.create_event_instance("event:/UI_sfx_1")
		sfx.start()
		sfx.release()
		
		if current_dialogue.terminate:
			print("Terminating")
			end_dialogue()
		else:
			start_dialogue(current_dialogue.next_dialogue)
 
