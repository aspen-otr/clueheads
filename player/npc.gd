@abstract
extends Player
class_name NPC

func _init(ident_: Card.Suspect) -> void:
	super(ident_)

@abstract func pick_card_to_show(suggestion: Set) -> int

@abstract func pick_square_to_move_to(possible_squares)

func show_card(suggestion: Set) -> Card:
	var matching = get_matching_cards(suggestion)

	if matching.is_empty():
		card_show.emit(self, null)
		return null

	var selected = pick_card_to_show(suggestion)

	if not selected in matching:
		push_error("NPC selected an invalid card")
		card_show.emit(self, null)
		return null

	card_shown.emit(self, selected)
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
