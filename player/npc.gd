@abstract
extends Player
class_name NPC


var character_name: String = "Unknown"
var current_room: String = "Hallway"

var cards: Array[Card] = []

signal room_changed(npc, new_room)
signal card_shown(npc, card)


func _init(ident_: Card.Suspect) -> void:
	super(ident_)
	character_name = Card.Suspect.keys()[ident_]


func set_cards(new_cards: Array[Card]) -> void:
	cards = new_cards.duplicate()


func get_matching_card_indices(suggestion: Set) -> Array[int]:
	var matching_indices: Array[int] = []

	for i in range(cards.size()):
		if suggestion.has(cards[i]):
			matching_indices.append(i)

	return matching_indices


@abstract func pick_card_to_show(suggestion: Set) -> int


@abstract func pick_square_to_move_to(possible_squares)


func show_card(suggestion: Set) -> Card:
	var matching_indices = get_matching_card_indices(suggestion)

	if matching_indices.is_empty():
		return null

	var selected_index = pick_card_to_show(suggestion)

	if not selected_index in matching_indices:
		push_error("NPC selected an invalid card")
		return null

	var selected_card = cards[selected_index]
	card_shown.emit(self, selected_card)

	return selected_card


func choose_destination(possible_squares):
	if possible_squares.is_empty():
		return null

	var selected_square = pick_square_to_move_to(possible_squares)

	if not selected_square in possible_squares:
		push_error("NPC selected an invalid square")
		return null

	return selected_square


func move_to_room(room_name: String) -> void:
	current_room = room_name
	room_changed.emit(self, room_name)


func get_npc_info() -> Dictionary:
	return {
		"name": character_name,
		"ident": ident,
		"room": current_room,
		"card_count": cards.size()
	}
