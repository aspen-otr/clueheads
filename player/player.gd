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
<<<<<<< HEAD
		# TODO: Show a popup and let the human player choose a matching card.
		return -1
=======
		# popups to pick
		return 0
>>>>>>> a2d0e50991d162429e1b28f91d4e49c49b81ddb7

	func pick_square_to_move_to(possible_squares):
		# allow clicking on board
		pass
