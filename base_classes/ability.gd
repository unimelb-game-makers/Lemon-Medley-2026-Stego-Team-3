@abstract
extends Node
class_name Ability

@export var key: Key
@export var input: String

@export var cooldown: float

@onready var cooldown_timer: Timer = $cooldown_timer # Each ability/curse will have a timer for their own cooldown

var controller: Player
var activated: bool = false ## Set true in activate() function, and set false whenever ability running period ends.

## Activate the ability -> One shot
@abstract func activate()

## Run the ability -> Continuous after activation
@abstract func run()
