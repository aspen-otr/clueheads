extends GutTest


func test_advance_player_moves_to_next_suspect() -> void:
	var next_player: Card.Suspect = Game.advance_player(
		Card.Suspect.MissScarlett
	)

	assert_eq(
		next_player,
		Card.Suspect.ColonelMustard,
		"Miss Scarlett should advance to Colonel Mustard."
	)


func test_advance_player_wraps_back_to_miss_scarlett() -> void:
	var next_player: Card.Suspect = Game.advance_player(
		Card.Suspect.DrOrchid
	)

	assert_eq(
		next_player,
		Card.Suspect.MissScarlett,
		"Dr. Orchid should wrap around to Miss Scarlett."
	)


func test_advance_player_cycles_through_all_suspects() -> void:
	var player: Card.Suspect = Card.Suspect.MissScarlett

	player = Game.advance_player(player)
	assert_eq(player, Card.Suspect.ColonelMustard)

	player = Game.advance_player(player)
	assert_eq(player, Card.Suspect.ProfessorPlum)

	player = Game.advance_player(player)
	assert_eq(player, Card.Suspect.MrGreen)

	player = Game.advance_player(player)
	assert_eq(player, Card.Suspect.MrsPeacock)

	player = Game.advance_player(player)
	assert_eq(player, Card.Suspect.DrOrchid)

	player = Game.advance_player(player)
	assert_eq(player, Card.Suspect.MissScarlett)


func test_is_npc_returns_false_for_real_player() -> void:
	var real_players: Array[Card.Suspect] = [
		Card.Suspect.MissScarlett
	]

	var game: Game = Game.new(real_players)

	assert_false(
		game.is_npc(Card.Suspect.MissScarlett),
		"Miss Scarlett should be recognized as a real player."
	)

	game.free()


func test_is_npc_returns_true_for_non_real_player() -> void:
	var real_players: Array[Card.Suspect] = [
		Card.Suspect.MissScarlett
	]

	var game: Game = Game.new(real_players)

	assert_true(
		game.is_npc(Card.Suspect.ColonelMustard),
		"Colonel Mustard should be recognized as an NPC."
	)

	game.free()


func test_multiple_real_players_are_not_npcs() -> void:
	var real_players: Array[Card.Suspect] = [
		Card.Suspect.MissScarlett,
		Card.Suspect.ProfessorPlum
	]

	var game: Game = Game.new(real_players)

	assert_false(
		game.is_npc(Card.Suspect.MissScarlett),
		"Miss Scarlett should be a real player."
	)

	assert_false(
		game.is_npc(Card.Suspect.ProfessorPlum),
		"Professor Plum should be a real player."
	)

	assert_true(
		game.is_npc(Card.Suspect.ColonelMustard),
		"Colonel Mustard should be an NPC."
	)

	game.free()
