extends NPC
class_name StrategicNPC

var previously_shown_cards: Array[Card] = []


func _init(ident_: Card.Suspect) -> void:
	super(ident_)


func pick_card_to_show(suggestion: Set) -> Card:
	var matching = get_matching_cards(suggestion)
	if matching.is_empty():
		return null
	# Prefer showing a card already revealed
	for card in matching:
		if card in previously_shown_cards:
			return card
	return matching[0]


func show_card(suggestion: Set) -> Card:
	var selected_card = super.show_card(suggestion)

	if selected_card != null:
		if not selected_card in previously_shown_cards:
			previously_shown_cards.append(selected_card)

	return selected_card


func pick_square_to_move_to(possible_squares):
	if possible_squares.is_empty():
		return null

	return possible_squares[0]
