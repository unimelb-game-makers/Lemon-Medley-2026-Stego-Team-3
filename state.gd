@abstract
class_name State
extends Node

var controlled_character : CharacterBody2D
var state_name : String

@abstract func on_enter()
@abstract func on_exit()
@abstract func process_state(delta : float)
