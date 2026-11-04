extends GutTest


func make_suspect_card(suspect: Card.Suspect) -> Card:
	var card: Card = Card.new()
	card.type = Card.Type.SUSPECT
	card.suspect = suspect
	return card


func make_weapon_card(weapon: Card.Weapon) -> Card:
	var card: Card = Card.new()
	card.type = Card.Type.WEAPON
	card.weapon = weapon
	return card


func make_room_card(room: Card.Room) -> Card:
	var card: Card = Card.new()
	card.type = Card.Type.ROOM
	card.room = room
	return card


func test_set_has_matching_suspect() -> void:
	var suspect_card: Card = make_suspect_card(Card.Suspect.MissScarlett)
	var weapon_card: Card = make_weapon_card(Card.Weapon.Rope)
	var room_card: Card = make_room_card(Card.Room.Library)

	var cards: Array[Card] = [
		suspect_card,
		weapon_card,
		room_card
	]

	var card_set: Set = Set.new(cards)

	assert_true(
		card_set.has(suspect_card),
		"Set should contain the Miss Scarlett card."
	)

	suspect_card.free()
	weapon_card.free()
	room_card.free()


func test_set_has_matching_weapon() -> void:
	var suspect_card: Card = make_suspect_card(Card.Suspect.ProfessorPlum)
	var weapon_card: Card = make_weapon_card(Card.Weapon.Candlestick)
	var room_card: Card = make_room_card(Card.Room.Kitchen)

	var cards: Array[Card] = [
		suspect_card,
		weapon_card,
		room_card
	]

	var card_set: Set = Set.new(cards)

	assert_true(
		card_set.has(weapon_card),
		"Set should contain the Candlestick card."
	)

	suspect_card.free()
	weapon_card.free()
	room_card.free()


func test_set_has_matching_room() -> void:
	var suspect_card: Card = make_suspect_card(Card.Suspect.MrGreen)
	var weapon_card: Card = make_weapon_card(Card.Weapon.Wrench)
	var room_card: Card = make_room_card(Card.Room.Study)

	var cards: Array[Card] = [
		suspect_card,
		weapon_card,
		room_card
	]

	var card_set: Set = Set.new(cards)

	assert_true(
		card_set.has(room_card),
		"Set should contain the Study card."
	)

	suspect_card.free()
	weapon_card.free()
	room_card.free()


func test_set_returns_false_for_card_not_in_set() -> void:
	var suspect_card: Card = make_suspect_card(Card.Suspect.MissScarlett)
	var weapon_card: Card = make_weapon_card(Card.Weapon.Rope)
	var room_card: Card = make_room_card(Card.Room.Library)

	var missing_card: Card = make_weapon_card(Card.Weapon.Revolver)

	var cards: Array[Card] = [
		suspect_card,
		weapon_card,
		room_card
	]

	var card_set: Set = Set.new(cards)

	assert_false(
		card_set.has(missing_card),
		"Set should not contain the Revolver card."
	)

	suspect_card.free()
	weapon_card.free()
	room_card.free()
	missing_card.free()


func test_set_can_find_all_three_card_types() -> void:
	var suspect_card: Card = make_suspect_card(Card.Suspect.MrsPeacock)
	var weapon_card: Card = make_weapon_card(Card.Weapon.Knife)
	var room_card: Card = make_room_card(Card.Room.Ballroom)

	var cards: Array[Card] = [
		suspect_card,
		weapon_card,
		room_card
	]

	var card_set: Set = Set.new(cards)

	assert_true(card_set.has(suspect_card))
	assert_true(card_set.has(weapon_card))
	assert_true(card_set.has(room_card))

	suspect_card.free()
	weapon_card.free()
	room_card.free()
