@abstract
class_name Player
extends Node

signal room_changed(player, new_room)
signal card_shown(player, card)

var ident: Card.Suspect

var character_name: String = "Unknown"
var current_room: String = "Hallway"

var cards: Array[Card] = []

func set_cards(new_cards: Array[Card]) -> void:
	cards = new_cards.duplicate()

func get_matching_cards(suggestion: Set) -> Array[Card]:
	return cards.filter(suggestion.has)

@abstract func pick_card_to_show(suggestion: Set) -> Card # Index of card returned.
@abstract func pick_square_to_move_to(possible_squares) # TODO: Square type?

func _init(ident_: Card.Suspect):
	self.ident = ident_
	self.character_name = Card.Suspect.keys()[ident_]

class HumanPlayer extends Player:
	func pick_from_cards(cards_available: Array[Card]) -> Card:
		return await Popups.popup_single_choice(cards_available)

	func pick_card_to_show(suggestion: Set) -> Card:
		var choose_from = get_matching_cards(suggestion)
		var pick = await pick_from_cards(choose_from)
		if (pick != null):
			card_shown.emit(self, pick)
			return pick
		return null

	func pick_square_to_move_to(possible_squares):
		# allow clicking on board
		pass
