class_name SaveState extends Resource

const SAVEPATH = "res://save.tres"

@export var level_path : String
@export var target_transition : String
@export var position_offset : Vector2
@export var player_stats : StatSheet

func save_game():
	ResourceSaver.save(self, SAVEPATH)

static func load_game() -> SaveState:
	if(ResourceLoader.exists(SAVEPATH)):
		return ResourceLoader.load(SAVEPATH)
	return null
