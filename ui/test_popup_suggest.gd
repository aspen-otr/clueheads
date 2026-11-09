extends Button

func _on_pressed() -> void:
	Card.set_all_lut()
	var result = await Popups.popup_suggest_accuse(Popups.PopupSuggestAccuse.SUGGESTION, [Card.new(Card.Type.ROOM, Card.Room.Library)])
	if result != null:
		for card in result.cards:
			print(card.value)
	else:
		print(result)
