extends Node

@onready var board_visuals: TileMapLayer = $"res://game_board/board_tile.gd"

var board_width: int = 24
var board_height: int = 23
var board_grid: Array = []

func _ready() -> void:
	initialize_board1()
	
	
#replaces a tile on the board grid with the board tile object passed as a perameter 
func change_board_tile(coords: Array, p_board_tile: board_tile ) -> void:
	var x = coords[0] + p_board_tile.tile_x
	var y = coords[1] + p_board_tile.tile_y
	if (p_board_tile.is_walkable == true):
		if (x >= 0 and x < board_width and y >= 0 and y < board_height):
			board_grid[x][y].room_type = p_board_tile.room_type
	else:
		print("tile is not walkable")
		

func add_room_to_grid(added_room: room) -> void:
	for i in range(added_room.doors.size()):
		var door_coords: Array = added_room.doors[i]
		board_grid[door_coords[0]][door_coords[1]].room_type = board_tile.ROOM_TYPE.DOOR
	for i in range(added_room.room_grid.size()):
		for k in range(added_room.room_grid[i].size()):
			var added_board_tile: board_tile = added_room.get_room_tile([i, k])
			var target_coords = [added_room.room_cords[0], added_room.room_cords[1]]
			change_board_tile(target_coords, added_board_tile)

#adds a spawn tile at the coords given. Spawn tile can 
#be at any viable location on the board. the function takes 
#the room type of the tile that you want to make a spawn tile, 
#and uses that room type to construct a new spawn tile object to 
#replace the one at the coords given
func add_spawn_tile(coords: Array) -> void :
	var target_tile_room_type = get_tile_room_type(coords)
	var spawn_tile = board_tile.new(0, 0, true, true, target_tile_room_type)
	change_board_tile(coords, spawn_tile)




func add_board1_spawn_tiles():
	add_spawn_tile([10, 1])
	add_spawn_tile([16, 1])
	add_spawn_tile([1, 8])
	add_spawn_tile([1, 20])
	add_spawn_tile([24, 7])
	add_spawn_tile([24, 18])
	add_spawn_tile([17, 23])
	add_spawn_tile([8, 23])
func initialize_board1() -> void:
	board_grid = []
	for x in range(board_width):
		var column = []
		for y in range(board_height):
			column.append(board_tile.new(x, y, false, true, board_tile.ROOM_TYPE.HALLWAY))
		board_grid.append(column)
	
	var conservatory_room = room.new(1, 1, board_tile.ROOM_TYPE.CONSERVATORY)
	add_room_to_grid(conservatory_room)
	var billiard_room = room.new(1, 8, board_tile.ROOM_TYPE.BILLIARD)
	add_room_to_grid(billiard_room)
	var library_room = room.new(1, 14, board_tile.ROOM_TYPE.LIBRARY)
	add_room_to_grid(library_room)
	var study_room = room.new(1, 21, board_tile.ROOM_TYPE.STUDY)
	add_room_to_grid(study_room)
	var ballroom_room = room.new(9, 1, board_tile.ROOM_TYPE.BALLROOM)
	add_room_to_grid(ballroom_room)
	var kitchen_room = room.new(19, 8, board_tile.ROOM_TYPE.KITCHEN)
	add_room_to_grid(kitchen_room)
	var dining_room = room.new(17, 9, board_tile.ROOM_TYPE.DINING)
	add_room_to_grid(dining_room)
	var lounge_room = room.new(18, 19, board_tile.ROOM_TYPE.LOUNGE)
	add_room_to_grid(lounge_room)
	var hall_room = room.new(10, 18, board_tile.ROOM_TYPE.HALL)
	add_room_to_grid(hall_room)
	var staircase = room.new(10, 10, board_tile.ROOM_TYPE.STAIRCASE)
	add_room_to_grid(staircase)
	add_board1_spawn_tiles()

func get_tile_room_type(cords: Array) -> board_tile.ROOM_TYPE:
	if cords[0] >= 0 and cords[0] < board_width and cords[1] >= 0 and cords[1] < board_height:
		return board_grid[cords[0]][cords[1]].room_type
	return board_tile.ROOM_TYPE.NONE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
