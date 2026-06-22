extends Node

const PLAYER = preload("res://characters/player/player_character.tscn")
var player : Player
var player_spawned : bool = false

signal camera_shook( trauma : float )
signal interact_pressed

func _ready() -> void:
	# I'll leave this here in case it doesn't load in time for other devices
	# but the fmod banks need to load first before everything
	#while not FmodManager.banks_loaded:
		#await get_tree().process_frame
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true

#region Player Instantion and Transitions
func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child( player )

func set_player_position( _new_pos : Vector2 ) -> void:
	while player == null:
		await get_tree().process_frame
	player.global_position = _new_pos
	pass

func set_as_parent( _p : Node2D ) -> void:
	if player.get_parent():
		player.get_parent().remove_child( player )
	_p.add_child( player )

func unparent_player( _p : Node2D ) -> void:
	_p.remove_child( player )

func hide_player() -> void:
	if not PlayerManager.player:
		return
	PlayerManager.player.visible = false
	PlayerManager.player.set_process_unhandled_input(false)
	PlayerManager.player.set_process(false)
	PlayerManager.player.stop_abilities()

func show_player() -> void:
	PlayerManager.player.visible = true
	PlayerManager.player.set_process_unhandled_input(true)
	PlayerManager.player.set_process(true)
	PlayerManager.player.continue_abilities()
#endregion

#region Camera
func shake_camera( trauma : float = 1 ) -> void:
	camera_shook.emit( clampi( trauma, 0, 3 ) )
#endregion

func interact() -> void:
	interact_pressed.emit()
