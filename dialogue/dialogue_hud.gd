@tool
class_name DialogueHUD extends CanvasLayer

@export var dialogue_text : RichTextLabel
@export var name_text : RichTextLabel
@export var is_active : bool = false
var dialogue_finished : bool = false
var current_dialogue : Dialogue = null

func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child(self)
			return
		return
	
	visible = is_active
	pass

func start_dialogue(dialogue : Dialogue) -> void:
	PlayerManager.player.state_machine.switch_state("dialogue")
	
	visible = true
	current_dialogue = dialogue
	
	dialogue_text.text = current_dialogue.dialogue_text
	name_text.text = current_dialogue.character_resource.character_name
	
	# Wait first so that the Interact input does not get handled twice
	await get_tree().process_frame
	await get_tree().process_frame
	
	is_active = true

func end_dialogue() -> void:
	is_active = false
	visible = false
	
	PlayerManager.player.state_machine.switch_state("idle")
	
	dialogue_text.text = ""
	name_text.text = ""
	current_dialogue = null

func _unhandled_input(event: InputEvent) -> void:
	if !is_active:
		return 
	
	if Input.is_action_pressed("Interact"):
		if current_dialogue.terminate:
			end_dialogue()
		else:
			start_dialogue(current_dialogue.next_dialogue)
