@abstract
class_name Player
extends Node

var ident: Card.Suspect

@abstract func pick_card_to_show(suggestion: Set) -> int # Index of card returned.
@abstract func pick_square_to_move_to(possible_squares) # TODO: Square type?

func _init(ident_: Card.Suspect):
	self.ident = ident_

class HumanPlayer extends Player:
	func pick_card_to_show(suggestion: Set) -> int:
		# popups to pick
		return 0

	func pick_square_to_move_to(possible_squares):
		# allow clicking on board
		pass
