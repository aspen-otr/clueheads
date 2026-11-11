extends Node2D
class_name Game

# The game behavior wherein the gameplay loop is performed.
# Not including the main menu, etc.

signal dice_rolled(player: Card.Suspect, dice: Array[int], total: int)

var current_player: Card.Suspect = Card.Suspect.MissScarlett
var _real_player_lut: Array[bool] = []

var dice: Dice = Dice.new()
var last_dice_roll: Array[int] = []
var last_roll_total: int = 0

@onready var game_board: Node2D = $GameBoard 

#var active_players: Array = [] 

func place_players(num_players):
	for i in range(num_players):
		game_board.active_players.append(Player.new(Color(1-(i%4), 0+(i%2), 0+(i%3)), Card.Suspect.MissScarlett))
	for i in range(len(game_board.active_players)):
		game_board.move_player(i, game_board.spawn_tile_coords[i])
		
	
	
func setup_real_players(real_players: Array[Card.Suspect]) -> void:
	self._real_player_lut.resize(Card.Suspect.size())

	for idx in range(Card.Suspect.size()):
		self._real_player_lut[idx] = idx in real_players

	Card.set_all_lut()


func _ready() -> void:
	setup_real_players([Card.Suspect.MissScarlett, Card.Suspect.ColonelMustard])
	
	game_board.initialize_board1()
	place_players(4)
	
	game_board.queue_redraw()

#region Static functions

static func advance_player(player: Card.Suspect) -> Card.Suspect:
	return (((player as int) + 1) % Card.Suspect.size()) as Card.Suspect

#endregion Static functions








func game_loop():
	while true:
		if self.is_npc(self.current_player):
			pass
		else:
			pass

		self.current_player = self.advance_player(self.current_player)


func roll_dice() -> int:
	last_dice_roll = dice.roll()
	last_roll_total = dice.total(last_dice_roll)

	dice_rolled.emit(
		current_player,
		last_dice_roll,
		last_roll_total
	)

	return last_roll_total


func suggest():
	pass


func accuse():
	pass


func disprove(_suggestion: Set) -> Variant:
	# [Card.Suspect, Card]

	assert(false, "unimplemented")

	var current_disprover: Card.Suspect = Game.advance_player(
		self.current_player
	)

	while current_disprover != self.current_player:
		current_disprover = Game.advance_player(
			current_disprover
		)

	return []


#region Utility instance functions

func is_in_room(player: Card.Suspect) -> bool:
	return self.room(player) != Card.Room_type.size()


func room(_player: Card.Suspect) -> Card.Room_type:
	# If x < Card.Room.size(), we have a room.
	# Assume we're not in one for now.

	return Card.Room_type.size() as Card.Room_type


func is_npc(index: int) -> bool:
	return not self._real_player_lut[index]

#endregion
