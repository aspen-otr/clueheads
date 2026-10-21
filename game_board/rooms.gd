extends Node
class_name room

var room_width: int 
var room_height: int 
var room_grid: Array = []
var room_coords: Array = []
var doors: Array = []
var hallway_tiles: Array = []
var room_type: board_tile.ROOM_TYPE = board_tile.ROOM_TYPE.NONE

func get_room_tile(cords: Array) -> board_tile:
	return room_grid[cords[0]][cords[1]] as board_tile

func change_room_tile(cords: Array, p_room_type: board_tile.ROOM_TYPE) -> void:
	var x = cords[0]
	var y = cords[1]
	if x >= 0 and x < room_width+1 and y >= 0 and y < room_height+1:
		room_grid[x][y].room_type = p_room_type


#room classes
class kitchen extends room: 
	func _init():
		room_width = 6
		room_height = 6
		doors = [[2, 7]] # Fixed to 2D matching structure
		room_type = board_tile.ROOM_TYPE.KITCHEN
class study extends room:
	func _init():
		room_width = 7
		room_height = 4
		doors = [[0, -1]]
		room_type = board_tile.ROOM_TYPE.STUDY
class billiard extends room:
	func _init():
		room_width = 6
		room_height = 5
		doors = [[2, 6], [7, 2]]
		room_type = board_tile.ROOM_TYPE.BILLIARD
class ballroom extends room:
	func _init():
		room_width = 8
		room_height = 7
		doors = [[-1, 5],[2, 8],[7,8],[9,5]]
		hallway_tiles = [[1,1], [1, 2], [1, 7], [1, 8]]
		room_type = board_tile.ROOM_TYPE.BALLROOM
class conservatory extends room:
	func _init():
		room_width = 6
		room_height = 5
		doors = [[6, 5]]
		hallway_tiles = [[6, 5]]
		room_type = board_tile.ROOM_TYPE.CONSERVATORY
class library extends room:
	func _init():
		room_width = 7
		room_height = 5
		doors = [[3,-1], [8,3]]
		hallway_tiles = [[1, 7], [5, 7]]
		room_type = board_tile.ROOM_TYPE.LIBRARY
class hall extends room:
	func _init():
		room_width = 6
		room_height = 7
		doors = [[-1,3], [3, -1], [4, -1]]
		room_type = board_tile.ROOM_TYPE.HALL
class dining extends room:
	func _init():
		room_width = 8
		room_height = 7
		doors = [[-1, 4], [2, 8]]
		hallway_tiles = [[1,1], [1,2], [1, 3]]
		room_type = board_tile.ROOM_TYPE.DINING 
class lounge extends room:
	func _init():
		room_width = 6
		room_height = 6
		doors = [[1, -1]]
		room_type = board_tile.ROOM_TYPE.LOUNGE # Fixed copy-paste bug
class staircase extends room:
	func _init():
		room_width = 5
		room_height = 7
		room_type = board_tile.ROOM_TYPE.STAIRCASE


func make_new_room(p_room_type: board_tile.ROOM_TYPE) -> room:
	match p_room_type:
		board_tile.ROOM_TYPE.BALLROOM: return ballroom.new()
		board_tile.ROOM_TYPE.BILLIARD: return billiard.new()
		board_tile.ROOM_TYPE.STUDY: return study.new()
		board_tile.ROOM_TYPE.KITCHEN: return kitchen.new()
		board_tile.ROOM_TYPE.CONSERVATORY: return conservatory.new()
		board_tile.ROOM_TYPE.LIBRARY: return library.new()
		board_tile.ROOM_TYPE.HALL: return hall.new()
		board_tile.ROOM_TYPE.LOUNGE: return lounge.new()
		board_tile.ROOM_TYPE.DINING: return dining.new()
		board_tile.ROOM_TYPE.STAIRCASE: return staircase.new()
	return null

func initialize_room(p_room_type: board_tile.ROOM_TYPE) -> room:
	var new_room: room = make_new_room(p_room_type)
	for x in range(new_room.room_width):
		var column: Array = []
		for y in range(new_room.room_height):
			var new_tile = board_tile.new(x, y, true, p_room_type)
			column.append(new_tile)
		new_room.room_grid.append(column)
	for tile_coord in new_room.hallway_tiles:
		new_room.change_room_tile(tile_coord, board_tile.ROOM_TYPE.HALLWAY)
	return new_room

func _init(x: int, y: int, p_room_type: board_tile.ROOM_TYPE) -> void:
	room_coords = [x, y]
	initialize_room(p_room_type)
		



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
