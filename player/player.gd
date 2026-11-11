class_name Player
extends Node2D

var player_coords: Array
var player_hand: Vector2
var player_color: Color


var ident: Card.Suspect

func _init(p_player_color, ident_: Card.Suspect):
	self.ident = ident_
	player_color = p_player_color
	player_coords = [-1,-1]
	
# func pick_card_to_show(suggestion: Set) -> int


# func pick_square_to_move_to(possible_squares)


#func _init(ident_: Card.Suspect):
#	self.ident = ident_


class HumanPlayer extends Player:

	func pick_card_to_show(suggestion: Set) -> int:
		# TODO: Show a popup and let the human player
		# choose a matching card.

		return -1


	func pick_square_to_move_to(possible_squares):
		# Allow clicking on board.
		pass
