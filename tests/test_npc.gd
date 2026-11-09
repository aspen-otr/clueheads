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


func test_get_matching_card_indices_finds_cards_that_disprove_suggestion() -> void:
	var npc := RandomNPC.new(Card.Suspect.ProfessorPlum)
	var suspect := _make_suspect_card(Card.Suspect.MissScarlett)
	var weapon := _make_weapon_card(Card.Weapon.Rope)
	var room := _make_room_card(Card.Room.Library)
	var hand: Array[Card] = [suspect, weapon]
	var suggestion_cards: Array[Card] = [suspect, room, weapon]
	var suggestion := Set.new(suggestion_cards)

	npc.set_cards(hand)
	var matches := npc.get_matching_card_indices(suggestion)

	assert_eq(matches, [0, 1])

	npc.free()
	suggestion.free()
	suspect.free()
	weapon.free()
	room.free()


func test_show_card_returns_only_matching_card() -> void:
	var npc := RandomNPC.new(Card.Suspect.ColonelMustard)
	var matching_weapon := _make_weapon_card(Card.Weapon.Candlestick)
	var nonmatching_weapon := _make_weapon_card(Card.Weapon.Wrench)
	var suspect := _make_suspect_card(Card.Suspect.MrsPeacock)
	var room := _make_room_card(Card.Room.Ballroom)
	var hand: Array[Card] = [nonmatching_weapon, matching_weapon]
	var suggestion_cards: Array[Card] = [suspect, room, matching_weapon]
	var suggestion := Set.new(suggestion_cards)

	npc.set_cards(hand)
	var shown_card := npc.show_card(suggestion)

	assert_same(shown_card, matching_weapon)

	npc.free()
	suggestion.free()
	matching_weapon.free()
	nonmatching_weapon.free()
	suspect.free()
	room.free()


func test_show_card_returns_null_when_npc_cannot_disprove() -> void:
	var npc := RandomNPC.new(Card.Suspect.MrGreen)
	var held_weapon := _make_weapon_card(Card.Weapon.Wrench)
	var suggested_weapon := _make_weapon_card(Card.Weapon.Rope)
	var suspect := _make_suspect_card(Card.Suspect.DrOrchid)
	var room := _make_room_card(Card.Room.Study)
	var hand: Array[Card] = [held_weapon]
	var suggestion_cards: Array[Card] = [suspect, room, suggested_weapon]
	var suggestion := Set.new(suggestion_cards)

	npc.set_cards(hand)
	var shown_card := npc.show_card(suggestion)

	assert_null(shown_card)

	npc.free()
	suggestion.free()
	held_weapon.free()
	suggested_weapon.free()
	suspect.free()
	room.free()


func test_choose_destination_returns_one_of_possible_squares() -> void:
	var npc := RandomNPC.new(Card.Suspect.MrsPeacock)
	var possible_squares := ["Hall", "Library", "Kitchen"]

	var selected_square = npc.choose_destination(possible_squares)

	assert_true(selected_square in possible_squares)

	npc.free()


func test_move_to_room_updates_current_room() -> void:
	var npc := RandomNPC.new(Card.Suspect.DrOrchid)

	npc.move_to_room("Library")

	assert_eq(npc.current_room, "Library")

	npc.free()
