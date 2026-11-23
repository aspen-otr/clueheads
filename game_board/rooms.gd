extends Node
class_name Room

var room_width: int 
var room_height: int 
var room_grid: Array 
var tileset_coords: Vector2i = Vector2i(0, 0)

#coordinates of the Room within the game board, 
#bound to the bottom left corner of each Room
var room_coords: Array 

#keeps track of the coordinates of each door 
#of that Room object. These coordinates are updated 
#with the Room's coordinates to reflect their overall 
#place on the board once that Room is added to the board grid. 

#Also, the coordinates of each "door" is actually the coordinates 
#of the tile on the board right outside said door. This is because 
#that is the actual tile the player has to be on top of to get inside
# the Room of that door. This should make it very easy to pathfind for 
#player movement. Because if a player wants to get to the dining Room for 
#example, you just look up the doordinates of the doors of the dining Room object, 
#and check which is closer using the player's coordinates
var doors: Array 

#keeps track of which tiles in the Room grid are actually 
#hallway tiles. Not all Rooms are standard rectangles, 
#so this is nessesary if the board is to look like a normal one
var hallway_tiles: Array 

var room_type: Board_tile.ROOM_TYPE = Board_tile.ROOM_TYPE.NONE

func get_room_tile(cords: Array) -> Board_tile:
	return room_grid[cords[0]][cords[1]] as Board_tile

#changes the Room_TYPE of a tile in the Room grid with the 
#one passed as a perameter
func change_room_tile(cords: Array, p_room_type: Board_tile.ROOM_TYPE) -> void:
	var x = cords[0]
	var y = cords[1]
	if x >= 0 and x < room_width and y >= 0 and y < room_height:
		room_grid[x][y].room_type = p_room_type


#room classes
class kitchen extends Room: 
	func _init():
		room_width = 6
		room_height = 6
		doors = [[1, 6]] 
		room_type = Board_tile.ROOM_TYPE.KITCHEN
		#tileset_coords = Vector2i(6, 39)
class study extends Room:
	func _init():
		room_width = 7
		room_height = 4
		doors = [[0, -1]]
		room_type = Board_tile.ROOM_TYPE.STUDY
class billiard extends Room:
	func _init():
		room_width = 6
		room_height = 5
		doors = [[1, 5], [6, 1]]
		room_type = Board_tile.ROOM_TYPE.BILLIARD
class ballroom extends Room:
	func _init():
		room_width = 8
		room_height = 7
		doors = [[-1, 4],[1, 7],[6,7],[8,5]]
		hallway_tiles = [[0,0], [1, 0], [6, 0], [7, 0]]
		room_type = Board_tile.ROOM_TYPE.BALLROOM
class conservatory extends Room:
	func _init():
		room_width = 6
		room_height = 5
		doors = [[5, 4]]
		#hallway_tiles = [[5, 4]]
		room_type = Board_tile.ROOM_TYPE.CONSERVATORY
class library extends Room:
	func _init():
		room_width = 7
		room_height = 5
		doors = [[3,-1], [7,2]]
		hallway_tiles = [[6, 0], [6, 4]]
		room_type = Board_tile.ROOM_TYPE.LIBRARY
class hall extends Room:
	func _init():
		room_width = 6
		room_height = 7
		doors = [[-1,2], [2, -1], [3, -1]]
		room_type = Board_tile.ROOM_TYPE.HALL
class dining extends Room:
	func _init():
		room_width = 8
		room_height = 7
		doors = [[-1, 3], [1, 7]]
		hallway_tiles = [[0,0], [1,0], [2, 0]]
		room_type = Board_tile.ROOM_TYPE.DINING 
class lounge extends Room:
	func _init():
		room_width = 6
		room_height = 6
		doors = [[0, -1]]
		room_type = Board_tile.ROOM_TYPE.LOUNGE # Fixed copy-paste bug
class staircase extends Room:
	func _init():
		room_width = 5
		room_height = 7
		room_type = Board_tile.ROOM_TYPE.STAIRCASE


func make_new_room(p_room_type: Board_tile.ROOM_TYPE) -> Room:
	match p_room_type:
		Board_tile.ROOM_TYPE.BALLROOM: return ballroom.new()
		Board_tile.ROOM_TYPE.BILLIARD: return billiard.new()
		Board_tile.ROOM_TYPE.STUDY: return study.new()
		Board_tile.ROOM_TYPE.KITCHEN: return kitchen.new()
		Board_tile.ROOM_TYPE.CONSERVATORY: return conservatory.new()
		Board_tile.ROOM_TYPE.LIBRARY: return library.new()
		Board_tile.ROOM_TYPE.HALL: return hall.new()
		Board_tile.ROOM_TYPE.LOUNGE: return lounge.new()
		Board_tile.ROOM_TYPE.DINING: return dining.new()
		Board_tile.ROOM_TYPE.STAIRCASE: return staircase.new()
	return null

#fills the Room grid with tiles of the appropiate Room type. 
#Its also the function that updates the door coords with the 
#room coords
func initialize_room() -> void:
	room_grid.clear()
	for x in range(room_width):
		var column: Array = []
		for y in range(room_height):
			column.append(Board_tile.new(x, y, false, true, room_type))
		room_grid.append(column)
	for tile_coord in hallway_tiles:
		change_room_tile(tile_coord, Board_tile.ROOM_TYPE.HALLWAY)
	for i in range(doors.size()):
		doors[i] = [doors[i][0] + room_coords[0], doors[i][1] + room_coords[1]]
		
static func create(x: int, y: int, p_room_type: Board_tile.ROOM_TYPE) -> Room:
	var instance: Room = null
	match p_room_type:
		Board_tile.ROOM_TYPE.BALLROOM: instance = ballroom.new()
		Board_tile.ROOM_TYPE.BILLIARD: instance = billiard.new()
		Board_tile.ROOM_TYPE.STUDY: instance = study.new()
		Board_tile.ROOM_TYPE.KITCHEN: instance = kitchen.new()
		Board_tile.ROOM_TYPE.CONSERVATORY: instance = conservatory.new()
		Board_tile.ROOM_TYPE.LIBRARY: instance = library.new()
		Board_tile.ROOM_TYPE.HALL: instance = hall.new()
		Board_tile.ROOM_TYPE.LOUNGE: instance = lounge.new()
		Board_tile.ROOM_TYPE.DINING: instance = dining.new()
		Board_tile.ROOM_TYPE.STAIRCASE: instance = staircase.new()

	if instance != null:
		instance.room_coords = [x, y]
		instance.initialize_room()
	return instance




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
