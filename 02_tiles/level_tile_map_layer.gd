class_name LevelTileMapLayer extends TileMapLayer

@export var tile_size : float = 32
@export var update_bounds : bool = true

@export var walls: TileMapLayer
@export var blocking_door: TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if update_bounds:
		LevelManager.change_tilemap_bounds( _get_tilemap_bounds() )
	pass # Replace with function body.

func open_doors():
	blocking_door.enabled = false

func _get_tilemap_bounds() -> Array[ Vector2 ]:
	var bounds : Array[ Vector2 ] = []
	bounds.append(
		scale * (Vector2( get_used_rect().position * tile_size ) + position)
	)
	bounds.append(
		scale * (Vector2( get_used_rect().end * tile_size ) + position)
	)
	return bounds

## Both functions used to update navigation layer to remove
## tiles with walls on them
func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	if walls == null:
		return false
		
	if coords in walls.get_used_cells_by_id(1):
		return true
	return false

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if walls == null:
		return
		
	if coords in walls.get_used_cells_by_id(1):
		tile_data.set_navigation_polygon(0, null)
