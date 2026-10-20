extends Node
class_name room

var room_width: int 
var room_height: int 
var room_grid: Array = []
var room_cords: Array = []
var doors: Array = []
var hallway_tiles: Array = []

func get_room_tile(cords: Array) -> board_tile:
	var r_room_tile: board_tile = room_grid[cords[0]][ cords[1]]
	return r_room_tile

func change_room_tile(cords: Array, p_room_type: board_tile.ROOM_TYPE) -> void:
	var x = cords[0]
	var y = cords[1]
	if x >= 0 and x < room_width+1 and y >= 0 and y < room_height+1:
		room_grid[x][y].room_type = p_room_type


#room classes
class kitchen: 
	var room_width = 6
	var room_height = 6
	var doors = [2, 7]
	
	var room_type: board_tile.ROOM_TYPE = board_tile.ROOM_TYPE.KITCHEN
class study:
	var room_width = 7
	var room_height = 4
	var doors = [0, -1]
	
	var room_type: board_tile.ROOM_TYPE = board_tile.ROOM_TYPE.STUDY
class billiard:
	var room_width = 6
	var room_height = 5
	var doors = [[2, 6], [7, 2]]
	
	var room_type: board_tile.ROOM_TYPE = board_tile.ROOM_TYPE.BILLIARD
class ballroom:
	var room_width = 8
	var room_height = 7
	var doors = [[-1, 5],[2, 8],[7,8],[9,5]]
	var hallway_tiles = [[1,1], [1, 2], [1, 7], [1, 8]]
	var room_type: board_tile.ROOM_TYPE = board_tile.ROOM_TYPE.BALLROOM
class conservatory:
	var room_width = 6
	var room_height = 5
	var doors = [6, 5]
	var hallway_tiles = [6, 5]
	var room_type: board_tile.ROOM_TYPE = board_tile.ROOM_TYPE.CONSERVATORY
class library:
	var room_width = 7
	var room_height = 5
	var doors = [[3,-1], [8,3]]
	var hallway_tiles = [[1, 7], [5, 7]]
	var room_type: board_tile.ROOM_TYPE = board_tile.ROOM_TYPE.LIBRARY
class hall:
	var room_width = 6
	var room_height = 7
	var doors = [[-1,3], [3, -1], [4, -1]]
	var room_type: board_tile.ROOM_TYPE = board_tile.ROOM_TYPE.HALL
class dining:
	var room_width = 8
	var room_height = 7
	var doors = [[-1, 4], [2, 8]]
	var hallway_tiles = [[1,1], [1,2], [1, 3]]
	var room_type: board_tile.ROOM_TYPE = board_tile.ROOM_TYPE.DINING 
class lounge:
	var room_width = 6
	var room_height = 6
	var doors = [1, -1]
	
	var room_type: board_tile.ROOM_TYPE = board_tile.ROOM_TYPE.BALLROOM
class staircase:
	var room_width = 5
	var room_height = 7
	var room_type: board_tile.ROOM_TYPE = board_tile.ROOM_TYPE.STAIRCASE


func make_new_room(p_room_type: board_tile.ROOM_TYPE) -> room:
	if (p_room_type == board_tile.ROOM_TYPE.BALLROOM):
		var ballroom_room = ballroom.new()
		return ballroom_room
	elif (p_room_type == board_tile.ROOM_TYPE.BILLIARD):
		var billiard_room = billiard.new()
		return billiard_room
	elif (p_room_type == board_tile.ROOM_TYPE.STUDY):
		var study_room = study.new()
		return study_room
	elif (p_room_type == board_tile.ROOM_TYPE.KITCHEN):
		var kitchen_room = kitchen.new()
		return kitchen_room
	elif (p_room_type == board_tile.ROOM_TYPE.CONSERVATORY):
		var conservatory_room = conservatory.new()
		return conservatory_room
	elif (p_room_type == board_tile.ROOM_TYPE.LIBRARY):
		var library_room = library.new()
		return library_room
	elif (p_room_type == board_tile.ROOM_TYPE.HALL):
		var hall_room = hall.new()
		return hall_room
	elif (p_room_type == board_tile.ROOM_TYPE.LOUNGE):
		var lounge_room = lounge.new()
		return lounge_room
	elif (p_room_type == board_tile.ROOM_TYPE.DINING):
		var dining_room = dining.new()
		return dining_room
	return null

func initialize_room(p_room_type: board_tile.ROOM_TYPE) -> void:
	var new_room: room = make_new_room(p_room_type)
	for x in range(new_room.room_width):
		var column: Array = []
		for y in range(new_room.room_height):
			var new_tile = board_tile.new(x, y, true, p_room_type)
			column.append(new_room.new_tile)
		new_room.room_grid.append(column)
	for i in (new_room.hallway_tiles.size()):
		change_room_tile([new_room.hallway_tiles[i]], board_tile.ROOM_TYPE.HALLWAY)
	for i in (new_room.doors.size()):
		change_room_tile([new_room.doors[i]], board_tile.ROOM_TYPE.DOOR)

func _init(x: int, y: int, p_room_type: board_tile.ROOM_TYPE) -> void:
	var room_x: int = x
	var room_y: int = y
	@warning_ignore("unused_variable", "shadowed_variable")
	var room_cords = [room_x, room_y]
	initialize_room(p_room_type)
		
		



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
