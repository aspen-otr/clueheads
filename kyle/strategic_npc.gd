extends NPC
class_name StrategicNPC

# Prefer the first eligible card
func choose_card_to_show(
	matching_cards: Array[String]
) -> String:

	if matching_cards.is_empty():
		return ""

	return matching_cards[0]


# Prefer the Study when available
func choose_move(
	available_rooms: Array[String]
) -> String:

	if available_rooms.is_empty():
		return ""

	if "Study" in available_rooms:
		return "Study"

	return available_rooms[0]
