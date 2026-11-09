@abstract
class_name Player
extends Node

var ident: Card.Suspect


@abstract func pick_card_to_show(suggestion: Set) -> int


@abstract func pick_square_to_move_to(possible_squares)


func _init(ident_: Card.Suspect):
	self.ident = ident_


class HumanPlayer extends Player:

	func pick_card_to_show(suggestion: Set) -> int:
		# TODO: Show a popup and let the human player
		# choose a matching card.

		return -1


	func pick_square_to_move_to(possible_squares):
		# Allow clicking on board.
		pass
