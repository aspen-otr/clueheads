extends Button

func _on_pressed() -> void:
	var deck: Deck = Deck.new()
	var total_players = randi() % 5 + 2
	var player_num = randi() % total_players
	var cards: Array[Card] = deck.deal_to_player(total_players, player_num)
	Popups.enable_card_display(cards)
	
	print("Total Players:")
	print(total_players)
	print("Player Number:")
	print(player_num)
	print("Case File:")
	for card in deck.case_file.cards:
		print(card.pretty())
	print("Deck:")
	for card in deck.cards:
		print(card.pretty())
