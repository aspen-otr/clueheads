extends GutTest


func _make_suspect_card(suspect: Card.Suspect) -> Card:
	var card := Card.new()
	card.type = Card.Type.SUSPECT
	card.suspect = suspect
	return card


func _make_room_card(room: Card.Room) -> Card:
	var card := Card.new()
	card.type = Card.Type.ROOM
	card.room = room
	return card


func _make_weapon_card(weapon: Card.Weapon) -> Card:
	var card := Card.new()
	card.type = Card.Type.WEAPON
	card.weapon = weapon
	return card


func test_pick_card_to_show_prefers_previously_shown_matching_card() -> void:
	var npc := StrategicNPC.new(Card.Suspect.ProfessorPlum)
	var suspect := _make_suspect_card(Card.Suspect.MissScarlett)
	var weapon := _make_weapon_card(Card.Weapon.Rope)
	var room := _make_room_card(Card.Room.Library)
	var hand: Array[Card] = [suspect, weapon]
	var suggestion_cards: Array[Card] = [suspect, room, weapon]
	var suggestion := Set.new(suggestion_cards)

	npc.set_cards(hand)
	npc.previously_shown_cards.append(weapon)

	var selected_index := npc.pick_card_to_show(suggestion)

	assert_eq(selected_index, 1)

	npc.free()
	suggestion.free()
	suspect.free()
	weapon.free()
	room.free()


func test_show_card_remembers_newly_shown_card() -> void:
	var npc := StrategicNPC.new(Card.Suspect.MrGreen)
	var held_weapon := _make_weapon_card(Card.Weapon.LeadPipe)
	var suspect := _make_suspect_card(Card.Suspect.ColonelMustard)
	var room := _make_room_card(Card.Room.Hall)
	var hand: Array[Card] = [held_weapon]
	var suggestion_cards: Array[Card] = [suspect, room, held_weapon]
	var suggestion := Set.new(suggestion_cards)

	npc.set_cards(hand)
	var shown_card := npc.show_card(suggestion)

	assert_same(shown_card, held_weapon)
	assert_true(held_weapon in npc.previously_shown_cards)
	assert_eq(npc.previously_shown_cards.size(), 1)

	npc.free()
	suggestion.free()
	held_weapon.free()
	suspect.free()
	room.free()


func test_showing_same_card_twice_does_not_duplicate_history() -> void:
	var npc := StrategicNPC.new(Card.Suspect.MrsPeacock)
	var held_weapon := _make_weapon_card(Card.Weapon.Knife)
	var suspect := _make_suspect_card(Card.Suspect.DrOrchid)
	var room := _make_room_card(Card.Room.DiningRoom)
	var hand: Array[Card] = [held_weapon]
	var suggestion_cards: Array[Card] = [suspect, room, held_weapon]
	var suggestion := Set.new(suggestion_cards)

	npc.set_cards(hand)
	npc.show_card(suggestion)
	npc.show_card(suggestion)

	assert_eq(npc.previously_shown_cards.size(), 1)
	assert_same(npc.previously_shown_cards[0], held_weapon)

	npc.free()
	suggestion.free()
	held_weapon.free()
	suspect.free()
	room.free()


func test_pick_square_to_move_to_chooses_first_available_square() -> void:
	var npc := StrategicNPC.new(Card.Suspect.MissScarlett)
	var possible_squares := ["Study", "Kitchen", "Lounge"]

	var selected_square = npc.pick_square_to_move_to(possible_squares)

	assert_eq(selected_square, "Study")

	npc.free()
