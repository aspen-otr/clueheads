extends Window

# returns a Set, or null if canceled
signal popup_suggest_accuse_pressed

var guess_type: Popups.PopupSuggestAccuse
var item_lists: Array[ItemList]
var selected: Array[Card]

func popup_suggest_accuse(guess_type_: Popups.PopupSuggestAccuse, locked_options: Array[Card] = []) -> Set:
	guess_type = guess_type_
	_set_text()
	_type_labels()
	_selection_menus(locked_options)
	%PopupSuggestAccuse.popup()
	var result = await popup_suggest_accuse_pressed
	for child in %PopupSuggestAccuse/Contents/Selections.get_children():
		child.queue_free()
	%PopupSuggestAccuse.hide()
	return result

func _set_text():
	if guess_type == Popups.PopupSuggestAccuse.ACCUSATION:
		%PopupSuggestAccuse/Contents/Text.text = "Who are you accusing?"
		%PopupSuggestAccuse/Contents/Buttons/SuggestBtn.text = "Accuse"
	elif guess_type == Popups.PopupSuggestAccuse.SUGGESTION:
		%PopupSuggestAccuse/Contents/Text.text = "Who are you suggesting?"
		%PopupSuggestAccuse/Contents/Buttons/SuggestBtn.text = "Suggest"


func _type_labels():
	%PopupSuggestAccuse/Contents/Selections.columns = Set.types.size()
	for type in Set.types:
		var new_label = Label.new()
		new_label.text = Card.type_lut[type]
		%PopupSuggestAccuse/Contents/Selections.add_child(new_label)

func _selection_menus(locked_options: Array[Card]):
	item_lists.clear()
	for type in Set.types:
		var type_disabled: bool # whether this type has a locked value
		var still_available: Array # values that are still available in a lock
		for lock in locked_options:
			if lock.type == type:
				type_disabled = true
				still_available.append(lock.value)
		item_lists.append(ItemList.new())
		item_lists.back().auto_width = true
		item_lists.back().auto_height = true
		var i = 0
		for item in Card.TYPE_VALS[type]:
			var card = Card.new(type, item)
			item_lists.back().add_item(card.pretty())
			item_lists.back().set_item_metadata(i, card)
			if type_disabled:
				if still_available.has(Card.TYPE_VALS[type][item]):
					item_lists.back().select(i)
				else:
					item_lists.back().set_item_disabled(i, true)
			i += 1
		%PopupSuggestAccuse/Contents/Selections.add_child(item_lists.back())

func _retrieve_selected():
	selected.clear()
	for list in item_lists:
		for i in range(list.item_count):
			if list.is_selected(i):
				selected.append(list.get_item_metadata(i))
				break

func _suggest_pressed():
	_retrieve_selected()
	if selected.size() == item_lists.size():
		var confirmation = Popups.PopupYN.YES
		if guess_type == Popups.PopupSuggestAccuse.ACCUSATION:
			visible = false
			exclusive = false
			confirmation = await Popups.popup_yn("Are you sure you want to make an accusation?")
			exclusive = true
			visible = true
		if (confirmation == Popups.PopupYN.YES):
			popup_suggest_accuse_pressed.emit(Set.new(selected))

func _cancel_pressed():
	popup_suggest_accuse_pressed.emit(null)
