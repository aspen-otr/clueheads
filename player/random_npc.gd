extends NPC
class_name RandomNPC


func _init(ident_: Card.Suspect) -> void:
	super(ident_)


func pick_card_to_show(suggestion: Set) -> Card:
	var matching = get_matching_cards(suggestion)
	if matching.is_empty():
		return null
	return matching.pick_random()


func pick_square_to_move_to(possible_squares):
	if possible_squares.is_empty():
		return null

	return possible_squares.pick_random()
