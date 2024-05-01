@tool
extends Node2D

@export_category("Tilemaps")
@export var current_tilemap : TileMap
@export var decoration_spawning_tilemap : TileMap

@export_category("Sources")
@export var tile_source_to_spawn_on_array : Array[int]
@export var using_terrain : bool = false
@export var decoration_source_id : int

@export_category("Decoration Spawn Location")
@export var fill_inside_tiles : bool = false
@export var can_spawn_in_blocks : bool = false
@export var spawn_position: spawn_position_enum


@export_category("Functions")
@export var redecorate_tilemap : bool:
	set(value):
		redecorate_tilemap = value
		CallRedecoration()

@export var clear_decoration_tilemap : bool:
	set(value):
		clear_decoration_tilemap = value
		ClearDecorationTilemap()

enum spawn_position_enum { NONE , TOP , RIGHT , LEFT , BOTTOM, TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT , BOTTOM_RIGHT }


func CallRedecoration():
	RedecorateTilemap(tile_source_to_spawn_on_array, decoration_source_id)



func RedecorateTilemap(tile_source_list : Array, decoration_source):
	if Engine.is_editor_hint():
		#Remove previous decorations
		ClearDecorationTilemap()
		
		
		#Add new decorations
		var all_tiles : Array
		for i in tile_source_list:
			all_tiles += current_tilemap.get_used_cells_by_id(0, i) #get list of all tiles positions
		
		
		var tiles_with_restrictions : Array
		
		for tile in all_tiles: #runs through all tiles of the specific type
			var original_tile_pos = tile
			
			
			
			# ---------Settings---------
			
			if spawn_position != spawn_position_enum.NONE: #adds an offset to the spawn
				tile += ReturnVec2FromPosEnum(spawn_position) #adds offset from "spawn_position"
			
			
			if fill_inside_tiles == true: #makes decoration tiles only spawn in inside tiles
				if current_tilemap.get_cell_atlas_coords(0, original_tile_pos ) == Vector2i(9, 2): #check if the tile's atlas coords match that of the default "empty tile" position
					tile = original_tile_pos #if so, reset the tile offset
				else:
					continue #else go into the next iteration of the loop
			
			
			if can_spawn_in_blocks == false: #disables the tiles from spawning in blocks
				if current_tilemap.get_cell_source_id(0, tile) != -1: #checks if the tile its trying to spawn on is occupied
					continue
			
			
			
			
			# Spawn the tile
			if using_terrain == false:
				decoration_spawning_tilemap.set_cell(0 , tile, decoration_source, Vector2i(randi_range(0, 4), randi_range(0, 1))) #spawns tile
			else:
				tiles_with_restrictions.append(tile)
				#decoration_spawning_tilemap.set_cells_terrain_path(0, [tile], decoration_source, 0)
				#this in theory only fills the inside tiles
				#decoration_spawning_tilemap.set_cells_terrain_connect(0, tile, decoration_source, 0)
		
		
		#this fills everything with the terrain
		#clearing decorations tileset doesnt work cuz the tilemap and terrain arent teh same number 
		
		if using_terrain == true:
			decoration_spawning_tilemap.set_cells_terrain_connect(0, tiles_with_restrictions, decoration_source, 0)
		


func ClearDecorationTilemap():
	if Engine.is_editor_hint():
		var all_tile_decorations = decoration_spawning_tilemap.get_used_cells_by_id(0)#, decoration_source_id)
		for tile in all_tile_decorations:
			decoration_spawning_tilemap.erase_cell(0, tile) 

func ReturnVec2FromPosEnum(enum_state):
	if enum_state == spawn_position_enum.NONE:
		return Vector2i.ZERO
	elif enum_state == spawn_position_enum.TOP:
		return Vector2i(0, -1)
	elif enum_state == spawn_position_enum.BOTTOM:
		return Vector2i(0, 1)
	elif enum_state == spawn_position_enum.RIGHT:
		return Vector2i(1, 0)
	elif enum_state == spawn_position_enum.LEFT:
		return Vector2i(-1, 0)
	elif enum_state == spawn_position_enum.TOP_RIGHT:
		return Vector2i(1, -1)
	elif enum_state == spawn_position_enum.TOP_LEFT:
		return Vector2i(-1, -1)
	elif enum_state == spawn_position_enum.BOTTOM_RIGHT:
		return Vector2i(1, 1)
	elif enum_state == spawn_position_enum.BOTTOM_LEFT:
		return Vector2i(-1, 1)
	else:
		print("ReturnVec2FromPosEnum got an invalid enum state!")
