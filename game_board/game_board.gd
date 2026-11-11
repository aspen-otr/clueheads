extends Node2D

#@onready var board_visuals: TileMapLayer = $"res://game_board/board_visuals.png"


var board_grid: Array = []
var board_width: int
var board_height: int

var active_rooms: Array[Room] 
var spawn_tile_coords: Array
var active_players: Array[Player]

var tile_size: float = 0.0
var offset_x: float = 0.0
var offset_y: float = 0.0
var hovered_tile_coords: Array = [-1, -1]

var default_font: Font = Control.new().get_theme_font("font")
const ROOM_COLORS = {
	Board_tile.ROOM_TYPE.NONE: Color(0.0, 0.0, 0.0, 1.0),       
	Board_tile.ROOM_TYPE.HALLWAY: Color(0.877, 0.843, 0.74, 1.0),    
	Board_tile.ROOM_TYPE.DOOR: Color(0.85, 0.35, 0.25),       
	Board_tile.ROOM_TYPE.KITCHEN: Color(0.25, 0.55, 0.75),    
	Board_tile.ROOM_TYPE.BILLIARD: Color(0.20, 0.60, 0.35),   
	Board_tile.ROOM_TYPE.BALLROOM: Color(0.65, 0.40, 0.75),   
	Board_tile.ROOM_TYPE.CONSERVATORY: Color(0.30, 0.70, 0.65),
	Board_tile.ROOM_TYPE.LIBRARY: Color(0.65, 0.50, 0.35),    
	Board_tile.ROOM_TYPE.STUDY: Color(0.45, 0.55, 0.65),      
	Board_tile.ROOM_TYPE.HALL: Color(0.80, 0.60, 0.20),       
	Board_tile.ROOM_TYPE.DINING: Color(0.70, 0.30, 0.30),     
	Board_tile.ROOM_TYPE.LOUNGE: Color(0.85, 0.55, 0.30),     
	Board_tile.ROOM_TYPE.STAIRCASE: Color(0.245, 0.245, 0.245, 1.0)   
}
const ROOM_NAMES = {
	Board_tile.ROOM_TYPE.KITCHEN: "KITCHEN",
	Board_tile.ROOM_TYPE.BILLIARD: "BILLIARD",
	Board_tile.ROOM_TYPE.BALLROOM: "BALLROOM",
	Board_tile.ROOM_TYPE.CONSERVATORY: "CONSERVATORY",
	Board_tile.ROOM_TYPE.LIBRARY: "LIBRARY",
	Board_tile.ROOM_TYPE.STUDY: "STUDY",
	Board_tile.ROOM_TYPE.HALL: "HALL",
	Board_tile.ROOM_TYPE.DINING: "DINING",
	Board_tile.ROOM_TYPE.LOUNGE: "LOUNGE",
	Board_tile.ROOM_TYPE.STAIRCASE: "STAIRS"
}

func get_room_by_type(target_type: Board_tile.ROOM_TYPE) -> Room:
	for current_room in active_rooms:
		if (current_room.room_type == target_type):
			return current_room
			
	return null
func get_tile(cords: Array) -> Board_tile:
	if cords[0] >= 0 and cords[0] < board_width and cords[1] >= 0 and cords[1] < board_height:
		return board_grid[cords[0]][cords[1]]
	return null

func move_player(p_player: int, destination: Array):
	var p_player_coords
	if (active_players[p_player].player_coords != [-1,-1]):
		p_player_coords = active_players[p_player].player_coords
		board_grid[p_player_coords[0]][p_player_coords[1]].occupied_by = null
	board_grid[destination[0]][destination[1]].occupied_by = p_player
	active_players[p_player].player_coords = destination

func change_Board_tile(coords: Array, p_Board_tile: Board_tile ) -> void:
	var x = coords[0] + p_Board_tile.tile_x
	var y = coords[1] + p_Board_tile.tile_y
	
	if (x >= 0 and x < board_width and y >= 0 and y < board_height):
			board_grid[x][y].room_type = p_Board_tile.room_type
			board_grid[x][y].is_spawn_tile =  p_Board_tile.is_spawn_tile
			
	
		

func add_room_to_grid(added_room: Room) -> void:
	active_rooms.append(added_room)
	for i in range(added_room.room_grid.size()):
		for k in range(added_room.room_grid[i].size()):
			var added_Board_tile: Board_tile = added_room.get_room_tile([i, k])
			var target_coords = [added_room.room_coords[0], added_room.room_coords[1]]
			change_Board_tile(target_coords, added_Board_tile)
	for i in range(added_room.doors.size()):
		var door_coords: Array = added_room.doors[i]
		if door_coords[0] >= 0 and door_coords[0] < board_width and door_coords[1] >= 0 and door_coords[1] < board_height:
			board_grid[door_coords[0]][door_coords[1]].room_type = Board_tile.ROOM_TYPE.DOOR

#adds a spawn tile at the coords given. Spawn tile can 
#be at any viable location on the board. the function takes 
#the Room type of the tile that you want to make a spawn tile, 
#and uses that Room type to construct a new spawn tile object to 
#replace the one at the coords given
func add_spawn_tile(coords: Array) -> void :
	var target_tile_room_type: Board_tile.ROOM_TYPE = get_tile(coords).room_type
	spawn_tile_coords.append(coords)
	var spawn_tile = Board_tile.new(0, 0, true, true, target_tile_room_type)
	change_Board_tile(coords, spawn_tile)
	
func setup_board_grid():
	board_grid.clear()
	for x in range(board_width):
		var column = []
		for y in range(board_height):
			column.append(Board_tile.new(x, y, false, true, Board_tile.ROOM_TYPE.HALLWAY))
		board_grid.append(column)

func add_board1_spawn_tiles():
	add_spawn_tile([9, 0])
	add_spawn_tile([14, 0])
	add_spawn_tile([0, 5])
	add_spawn_tile([0, 19])
	add_spawn_tile([23, 6])
	add_spawn_tile([23, 17])
	add_spawn_tile([16, 23])
	add_spawn_tile([7, 23])

func initialize_board1() -> void:
	board_height = 24
	board_width = 24
	setup_board_grid()
	
	var conservatory_room = Room.create(0, 0, Board_tile.ROOM_TYPE.CONSERVATORY)
	add_room_to_grid(conservatory_room)
	var billiard_room = Room.create(0, 7, Board_tile.ROOM_TYPE.BILLIARD)
	add_room_to_grid(billiard_room)
	var library_room = Room.create(0, 13, Board_tile.ROOM_TYPE.LIBRARY)
	add_room_to_grid(library_room)
	var study_room = Room.create(0, 20, Board_tile.ROOM_TYPE.STUDY)
	add_room_to_grid(study_room)
	var ballroom_room = Room.create(8, 0, Board_tile.ROOM_TYPE.BALLROOM)
	add_room_to_grid(ballroom_room)
	var kitchen_room = Room.create(18, 0, Board_tile.ROOM_TYPE.KITCHEN)
	add_room_to_grid(kitchen_room)
	var dining_room = Room.create(16, 8, Board_tile.ROOM_TYPE.DINING)
	add_room_to_grid(dining_room)
	var lounge_room = Room.create(18, 18, Board_tile.ROOM_TYPE.LOUNGE)
	add_room_to_grid(lounge_room)
	var hall_room = Room.create(9, 17, Board_tile.ROOM_TYPE.HALL)
	add_room_to_grid(hall_room)
	var staircase = Room.create(9, 9, Board_tile.ROOM_TYPE.STAIRCASE)
	add_room_to_grid(staircase)
	add_board1_spawn_tiles()

func initialize_board2() -> void:
	board_height = 6
	board_width = 30
	setup_board_grid()
	
	var conservatory_room = Room.create(-2, -2, Board_tile.ROOM_TYPE.CONSERVATORY)
	add_room_to_grid(conservatory_room)
	var billiard_room = Room.create(5, -2, Board_tile.ROOM_TYPE.BILLIARD)
	add_room_to_grid(billiard_room)
	var library_room = Room.create(0, 4, Board_tile.ROOM_TYPE.LIBRARY)
	add_room_to_grid(library_room)
	var study_room = Room.create(24, 4, Board_tile.ROOM_TYPE.STUDY)
	add_room_to_grid(study_room)
	var ballroom_room = Room.create(12, -4, Board_tile.ROOM_TYPE.BALLROOM)
	add_room_to_grid(ballroom_room)
	var kitchen_room = Room.create(18, 0, Board_tile.ROOM_TYPE.KITCHEN)
	add_room_to_grid(kitchen_room)

func find_path(die_roll: int):
		var screen_x = hovered_tile_coords[0] * tile_size + offset_x
		var screen_y = (board_height - 1 - hovered_tile_coords[1]) * tile_size + offset_y
		var target_tile = get_tile(hovered_tile_coords)
		if (target_tile != null):
			#cursor will not highlight over the staircase because players cant move to the staircase
			if (target_tile.room_type != Board_tile.ROOM_TYPE.STAIRCASE):
				if (target_tile.room_type == Board_tile.ROOM_TYPE.HALLWAY):
					var cell_rect = Rect2(screen_x, screen_y, tile_size, tile_size)
					draw_rect(cell_rect, Color(0.165, 1.0, 0.027, 0.635), true)
					draw_rect(cell_rect, Color.BLACK, false, 1.0)
				else:
					var hovered_room: Room = get_room_by_type(target_tile.room_type)
					if (hovered_room != null):
						var base_x = hovered_room.room_coords[0]
						var base_y = hovered_room.room_coords[1]
						
						for x in range(hovered_room.room_width):
							for y in range(hovered_room.room_height):
								if ([x, y] not in hovered_room.hallway_tiles):
									var grid_x = base_x + x
									var grid_y = base_y + y
									
									screen_x = grid_x * tile_size + offset_x
									screen_y = (board_height - 1 - grid_y) * tile_size + offset_y
									
									var cell_rect = Rect2(screen_x, screen_y, tile_size, tile_size)
									draw_rect(cell_rect, Color(0.165, 1.0, 0.027, 0.616), true)
									draw_rect(cell_rect, Color.BLACK, false, 1.0)


func _process(_delta: float) -> void:
	if (tile_size <= 0): 
		return 
	
	var local_mouse: Vector2 = get_local_mouse_position()
		
		
	var grid_x: int = floor((local_mouse.x - offset_x) / tile_size)
	var grid_y: int = board_height - 1 - floor((local_mouse.y - offset_y) / tile_size)
		
	var current_hover= [1, -1]

	# Validate bounds
	if (grid_x >= 0 and grid_x < board_width and grid_y >= 0 and grid_y < board_height):
		current_hover = [grid_x, grid_y]
		
	#  update state and redraw if the hover location changed
	if (current_hover != hovered_tile_coords):
		if (hovered_tile_coords[0] != -1):
			board_grid[hovered_tile_coords[0]][hovered_tile_coords[1]].is_hovered = false
			
		if (current_hover[0] != -1):
			board_grid[current_hover[0]][current_hover[1]].is_hovered = true
			
		hovered_tile_coords = current_hover
		queue_redraw()
func _draw() -> void:
	if board_width == 0 or board_height == 0:
		return
	var window_size: Vector2i = get_window().size
	tile_size = (window_size.x / 2) / board_width
	offset_x = (window_size.x / 4)- (tile_size * board_width)/16
	offset_y = (window_size.y / 2) - (tile_size * board_height)/2

#draw board
	for x in range(board_width):
		for y in range(board_height):
			var current_tile: Board_tile = board_grid[x][y]
			if (current_tile.is_valid == true):
				var fill_color: Color
				if (current_tile.is_spawn_tile == false):
					fill_color = ROOM_COLORS.get(current_tile.room_type, Color.BLACK)
				else:
					fill_color =  Color(1.0, 0.0, 0.8, 1.0)
				# flip y axis
				var screen_x = x * tile_size + offset_x
				var screen_y = (board_height - 1 - y) * tile_size + offset_y
				var cell_rect = Rect2(screen_x, screen_y, tile_size, tile_size)

				draw_rect(cell_rect, fill_color, true)
				draw_rect(cell_rect, Color.BLACK, false, 1.0)

	find_path(6)

	#draw players
	for i in range(len(active_players)):
		var p_player_coords = active_players[i].player_coords
		
		# 1. Calculate the top-left corner of the tile
		var tile_left = p_player_coords[0] * tile_size + offset_x
		var tile_top = (board_height - 1 - p_player_coords[1]) * tile_size + offset_y
		
		# 2. Add half the tile size to find the exact center of the cell
		var center_x = tile_left + (tile_size / 2.0)
		var center_y = tile_top + (tile_size / 2.0)
		
		# 3. Draw the circle using the centered coordinates
		draw_circle(Vector2(center_x, center_y), tile_size / 3.0, active_players[i].player_color)
		
	#align Labels
	for current_room in active_rooms:
		if (not ROOM_NAMES.has(current_room.room_type)):
			continue

		var room_text: String = ROOM_NAMES[current_room.room_type]

		
		var center_board_x = current_room.room_coords[0] + (current_room.room_width / 2.0)
		var center_board_y = current_room.room_coords[1] + (current_room.room_height / 2.0)

		
		var global_pixel_x = (center_board_x * tile_size) + offset_x
		var global_pixel_y = ((board_height - 1 - center_board_y) * tile_size) + offset_y

		var font_size = 14
		var text_size = default_font.get_string_size(room_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
		var label_position = Vector2(global_pixel_x - (text_size.x / 2.0), global_pixel_y + (text_size.y / 4.0))

		draw_string(default_font, label_position, room_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.WHITE)
