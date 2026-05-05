
extends Node

var performance_display: PerformancesDisplay
var music_instance = null
var heartbeat_instance = null
var banks := Array()
var banks_loaded = false

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	performance_display = PerformancesDisplay.new()
	add_child(performance_display)
	
	banks.append(FmodServer.load_bank("res://assets/banks/Master.strings.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL))
	banks.append(FmodServer.load_bank("res://assets/banks/Master.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL))
	banks.append(FmodServer.load_bank("res://assets/banks/Music.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL))
	banks.append(FmodServer.load_bank("res://assets/banks/SFX.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL))
	banks_loaded = true
	
func _exit_tree() -> void:
	remove_child(performance_display)
	performance_display.free()

func _process(delta):
	FmodServer.update()
	
func _notification(what):
	FmodServer.notification(what)
