extends NPC
class_name RandomNPC

# Randomly select an eligible card
func choose_card_to_show(
	matching_cards: Array[String]
) -> String:

	if matching_cards.is_empty():
		return ""

	return matching_cards.pick_random()


# Randomly select the next room
func choose_move(
	available_rooms: Array[String]
) -> String:

	if available_rooms.is_empty():
		return ""

	return available_rooms.pick_random()
