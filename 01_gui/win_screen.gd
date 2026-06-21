extends PanelContainer

var menu_music: FmodEvent = null
var start_screen: PackedScene = preload("res://01_gui/start_screen/start_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	HUD.visible = false
	HUD.get_node("HealthBar").active = false
	HUD.set_process_unhandled_input(false)
	menu_music = FmodServer.create_event_instance("event:/title_screen")
	menu_music.start()
	
	get_tree().paused = false

func play_button_sfx() -> void:
	var event = FmodServer.create_event_instance("event:/UI_sfx_2")
	event.start()
	event.release()

func _on_start_button_pressed() -> void:
	play_button_sfx()
	get_tree().change_scene_to_packed(start_screen)
