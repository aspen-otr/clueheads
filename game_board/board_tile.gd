
extends RefCounted  # Inheriting RefCounted ensures automatic memory cleanup
class_name board_tile # This registers the class globally in Godot

enum ROOM_TYPE {NONE, DOOR, HALLWAY, LIBRARY, KITCHEN, BILLIARD, STUDY, HALL, CONSERVATORY, DINING, LOUNGE, BALLROOM, STAIRCASE }


var tile_x: int
var tile_y: int
var room_type: ROOM_TYPE = ROOM_TYPE.NONE

var is_spawn_tile: bool = false

#determines whether or not the player is able to travel on them
var is_walkable: bool = true
# Tracks if a player/clue is standing here
var occupied_by: Node = null 


func _init(p_x: int, p_y: int, p_is_spawn_tile: bool, p_is_walkable: bool, p_room_type: ROOM_TYPE) -> void:
	tile_x = p_x
	tile_y = p_y
	is_spawn_tile = p_is_spawn_tile
	#players cannot walk on the staircase that is on most 
	#iterations of the clue board, so it's not walkable by default
	if (p_room_type == ROOM_TYPE.STAIRCASE):
		is_walkable = false
	else:
		is_walkable = p_is_walkable
	room_type = p_room_type
