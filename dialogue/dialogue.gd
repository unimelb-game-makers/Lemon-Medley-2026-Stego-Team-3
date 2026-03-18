# Dialogue Tree using a Linked List architecture. We will have a "head" Dialogue node which
# we start from, and a pointer to the next Dialogue in the branch. We will have branching dialogues
# based on player choice (Choosing one dialogue option) or based on 
# environment variables (player fulfills an external condition e.g having a curse)
#
# IMPORTANT NOTE: DO NOT ACCIDENTALLY MAKE A RECURSIVE DIALOGUE BRANCH.
# 				  This happens when a pattern such as A -> B -> A.
@tool
class_name Dialogue extends Node

## The maximum depth of a Dialogue branch. Easiest way to solve against Recursion.
const MAXDEPTH = 100

## A pointer to the next dialogue in the dialogue chain. 
## Can be null if and only if its a terminal Dialogue. 
@export var next_dialogue : Dialogue

## Whether we want to stop the dialogue here. 
@export var terminate : bool

## What we want the dialogue to say
@export_multiline var dialogue_text : String = "PLACEHOLDER TEXT"

## Who is talking
@export var character_resource : CharacterResource

func _ready() -> void:
	if !character_resource:
		get_character_resource()

func get_character_resource() -> void:
	if character_resource == null:
		var p = self
		var _checking : bool = true
		while _checking == true:
			p = p.get_parent()
			if p:
				if p is NPC and p.character_resource:
					character_resource = p.character_resource
					_checking = false
			else:
				push_error("No character resource provided to dialogue and no parent has character resource to inherit from")
				_checking = false

func _get_configuration_warnings() -> PackedStringArray:
	var parent_node = get_parent()
	
	if parent_node is Dialogue:
		return []
	elif !get_valid_subtree():
		return ["Dialogue ends on a node that is not marked as ending dialogue or recursion has occured"]
		
	return []

## Recursive search to see if leaf nodes of our tree are marked as terminal
func get_valid_subtree(depth : int = 0) -> bool:
	# Stop against recursion
	if ++depth > MAXDEPTH:
		return false
		
	if !terminate:
		if next_dialogue == null:
			return false
		else:
			return next_dialogue.get_valid_subtree(depth)
	
	return true
