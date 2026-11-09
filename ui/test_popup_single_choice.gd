extends Button

func _on_pressed():
	var choices_as_indices = %EnabledChoiceList.get_selected_items()
	var choices: Array[Card] = []
	for index in choices_as_indices:
		choices.append(Card.from_string(%EnabledChoiceList.get_item_text(index)))
	print(choices)
	var res = await Popups.popup_single_choice(choices)
	if res != null:
		print(res.pretty())
	else:
		print("No card selected")
