extends CharacterBody2D
class_name NPC

# Information shared by all NPCs
@export var character_name: String = "Unknown"
@export var character_id: int = 0
@export var current_room: String = "Hallway"

# Cards this NPC is holding
var cards: Array[String] = []

# Signals
signal room_changed(npc, new_room)
signal card_shown(npc, card)

# Give NPC its cards
func set_cards(new_cards: Array[String]) -> void:
	cards = new_cards.duplicate()


# Abstract-style method
# Each NPC implementation must choose a card
func choose_card_to_show(
	matching_cards: Array[String]
) -> String:
	assert(false, "NPC must implement choose_card_to_show")
	return ""


# Abstract-style method
# Each NPC implementation must choose where to move
func choose_move(
	available_rooms: Array[String]
) -> String:
	assert(false, "NPC must implement choose_move")
	return ""


# Ask NPC to reveal one eligible card
func show_card(
	matching_cards: Array[String]
) -> String:
	if matching_cards.is_empty():
		return ""

	var selected_card = choose_card_to_show(matching_cards)

	if not selected_card in matching_cards:
		push_error("NPC selected an invalid card")
		return ""

	card_shown.emit(self, selected_card)
	return selected_card


# Ask NPC to decide its next room
func take_turn(
	available_rooms: Array[String]
) -> void:
	if available_rooms.is_empty():
		return

	var next_room = choose_move(available_rooms)

	if not next_room in available_rooms:
		push_error("NPC selected an invalid room")
		return

	current_room = next_room
	room_changed.emit(self, next_room)
