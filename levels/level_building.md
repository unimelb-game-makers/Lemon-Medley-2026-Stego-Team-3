# How do we do Level Building for this game?

## Step 1: Geometry

This step is to build the general layout of the map. 
Centralize all used tilemaps within res://02_tiles/

Use *LevelTileMapLayer* only, and exactly 1 per level.
- Make sure you assign the tilemap to the *LevelTileMapLayer*, because this makes the camera work correctly when panning.
- Multiple LevelTileMapLayer will make camera choice of which to use for panning ambiguous in the current setup.

Assign the global group *tile_layer* to the tilemap. 
- This will be used for data layer purposes like giving custom foot step noise depending on terrain.

Store all TileMap sprites in the res://02_tiles/sprites/

Need another TileMapLayer?
- Make a generic TileMapLayer for the level scene specifically.
- You do not need to put it in the 02_tiles folder.

## Step 2: Logic

Setup Player Entry
- We have a player_spawn.tscn you can use to spawn a player into a level.
- Just put it on the level in the position you want the player to spawn.

Setup Level Transitions
- We have level_transition.tscn and level_transition.tscn for an interact version rather than automatic.
- To use it, put it on a level and assign to it the level(.tscn) you want to transition to.
- target_transition_area is the case-sensitive name of the LevelTransition in another tscn you are linking to. This has to be set correctly as well.
- The other parameters under Collision Area Settings are to size the transition area correctly.

In progress:
	- Other objects that can be placed on the tscn like destructible objects will be added in later.

## Step 3: Light2D and LightOccluder2D

## Step 4: World Environment Node

## Step 5: Particles and Shaders
