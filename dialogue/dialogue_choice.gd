# USE FOR WHEN WE WANT BRANCHING DIALOGUE WHERE THE PLAYER CAN MAKE A CHOICE (e.g Do you need help? Yes or No)
class_name DialogueChoice extends Dialogue

## What options do we want to be able to say
@export var dialogue_options : Array[String]

## Where we want to route our dialogue given the options.
## E.g "Will you help me?" dialogue_options = ['yes', 'no'], 
## possible_text_dialogues = [DialogueA, DialogueB] where yes routes to DialogueA
@export var possible_next_dialogues : Array[Dialogue]

func _get_accessibility_configuration_warnings() -> PackedStringArray:
	if dialogue_options.size() != possible_next_dialogues.size():
		return ["Dialogue Choice has Mismatch Size of options to next_dialogues"]
	return []

func get_valid_subtree(depth : int = 0) -> bool:
	if ++depth > MAXDEPTH:
		return false
		
	for possible_next_dialogue in possible_next_dialogues:
		if possible_next_dialogue == self:
			continue
		elif possible_next_dialogue.get_valid_subtree(depth):
			# One of the branches leads to a terminal node
			return true
			
	# None of the branches lead to a terminal noe
	return false
