extends Node



var board_width: int = 24
var board_height: int = 24
var board_grid: Array = []

func _ready() -> void:
	initialize_board()
	
	

func change_board_tile(cords: Array, board_tile ) -> void:
	var tile_x: int = board_tile.tile_x
	var tile_y: int = board_tile.tile_y
	var x = cords[0] + tile_x
	var y = cords[1] + tile_y
	if x >= 0 and x < board_width+1 and y >= 0 and y < board_height+1:
		board_grid[x][y].room_type = board_tile.ROOM_TYPE

func add_room_to_grid(added_room: room) -> void:
	var added_room_grid: Array = added_room.room_grid
	for i in range(added_room_grid.size()):
		for k in range(added_room_grid[i].size()):
			var added_board_tile: board_tile = rooms.get_room_tile([i, k])
			change_board_tile([i,k], added_board_tile)

func initialize_board() -> void:
	board_grid = []
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

func get_tile_room_type(cords: Array, room) -> board_tile.ROOM_TYPE:
	var tile_room_type: board_tile.ROOM_TYPE = room.room_grid[cords[0]][cords[1]]
	return board_tile.ROOM_TYPE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
