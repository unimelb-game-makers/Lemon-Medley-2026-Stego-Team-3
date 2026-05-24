extends PanelContainer

var save_state : SaveState
@onready var continue_button = $VBoxContainer/ContinueButton
@onready var start_button = $VBoxContainer/StartButton

@export_file( "*.tscn" ) var start_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	HUD.visible = false
	HUD.set_process_unhandled_input(false)
	PlayerManager.hide_player()
	save_state = SaveState.load_game()
	
	if save_state == null:
		continue_button.disabled = true
	else:
		continue_button.pressed.connect(continue_game)
	
	start_button.pressed.connect(new_game)
	get_tree().paused = false

func new_game():
	save_state = SaveState.new()
	LevelManager.save_state = save_state
	HUD.get_node("HealthBar").initialise()
	HUD.set_process_unhandled_input(true)
	HUD.attach_cooldowns()
	LevelManager.load_new_level(start_level, "Enter", Vector2.ZERO)

func continue_game():
	PlayerManager.player.stats.load(save_state.player_stats)
	LevelManager.save_state = save_state
	HUD.get_node("HealthBar").initialise()
	HUD.set_process_unhandled_input(true)
	HUD.attach_cooldowns()
	LevelManager.load_new_level(save_state.level_path, 
								save_state.target_transition, 
								save_state.position_offset)
