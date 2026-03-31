class_name DialogueArea extends Area2D

## When we interact with this NPC which branch do we want to pursue?
## Set a default one, otherwise we will take the first one found among its children.
@export var dialogue_head : Dialogue

@export var active : bool = false

## TEMPORARY DEBUGGING LABEL CHANGE LATER
@export var debug_label : Label

func _ready() -> void:
	get_dialogue_head()
		
	area_entered.connect(_on_area_enter)
	area_exited.connect(_on_area_exit)

func get_dialogue_head() -> void:
	if dialogue_head:
		return
		
	for c in get_children():
		if c is Dialogue:
			dialogue_head = c
			return
	
	print("No Dialogues Found; Setting Inactive")
	active = false

func start_talk() -> void:
	DialogueManager.start_dialogue(dialogue_head)

func _on_area_enter(_a : Area2D) -> void:
	if !active:
		return
	
	debug_label.text = "Can Talk"
	
	PlayerManager.interact_pressed.connect(start_talk)
	
	pass

func _on_area_exit(_a : Area2D) -> void:
	if !active:
		return
		
	debug_label.text = "Cannot Talk"
	
	PlayerManager.interact_pressed.disconnect(start_talk)
