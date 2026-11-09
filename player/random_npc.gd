extends NPC
class_name RandomNPC


func _init(ident_: Card.Suspect) -> void:
	super(ident_)


func pick_card_to_show(suggestion: Set) -> int:
	var matching_indices = get_matching_card_indices(suggestion)

	if matching_indices.is_empty():
		return -1

	return matching_indices.pick_random()


func pick_square_to_move_to(possible_squares):
	if possible_squares.is_empty():
		return null

	return possible_squares.pick_random()
