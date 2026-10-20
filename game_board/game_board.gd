extends Node

@onready var board_visuals: TileMapLayer = $"res://game_board/board_tile.gd"

var board_width: int = 24
var board_height: int = 24
var board_grid: Array = []

func _ready() -> void:
	initialize_board1()
	
	

func change_board_tile(coords: Array, p_board_tile: board_tile ) -> void:
	var x = coords[0] + p_board_tile.tile_x
	var y = coords[1] + p_board_tile.tile_y
	if x >= 0 and x < board_width+1 and y >= 0 and y < board_height+1:
		board_grid[x][y].room_type = p_board_tile.room_type

func add_room_to_grid(added_room: room) -> void:
	for i in range(added_room.room_grid.size()):
		for k in range(added_room.room_grid[i].size()):
			var added_board_tile: board_tile = added_room.get_room_tile([i, k])
			var target_coords = [added_room.room_cords[0], added_room.room_cords[1]]
			change_board_tile(target_coords, added_board_tile)

func initialize_board1() -> void:
	board_grid = []
	for x in range(board_width):
		var column = []
		for y in range(board_height):
			column.append(board_tile.new(x, y, true, board_tile.ROOM_TYPE.HALLWAY))
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

func get_tile_room_type(cords: Array) -> board_tile.ROOM_TYPE:
	if cords[0] >= 0 and cords[0] < board_width and cords[1] >= 0 and cords[1] < board_height:
		return board_grid[cords[0]][cords[1]].room_type
	return board_tile.ROOM_TYPE.NONE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
