extends Control

# returns a Set, or null if canceled
signal popup_suggest_accuse_pressed

var item_lists: Array[ItemList]
var selected: Array[Card]

func popup_suggest_accuse() -> Set:
	_type_labels()
	_selection_menus()
	%PopupSuggestAccuse.popup()
	var result = await popup_suggest_accuse_pressed
	for child in %PopupSuggestAccuse/Contents/Selections.get_children():
		child.queue_free()
	%PopupSuggestAccuse.hide()
	return result
	
func _type_labels():
	%PopupSuggestAccuse/Contents/Selections.columns = Set.types.size()
	for type in Set.types:
		var new_label = Label.new()
		new_label.text = Card.type_lut[type]
		%PopupSuggestAccuse/Contents/Selections.add_child(new_label)
		
func _selection_menus():
	item_lists.clear()
	for type in Set.types:
		item_lists.append(ItemList.new())
		item_lists.back().auto_width = true
		item_lists.back().auto_height = true
		var i = 0
		for item in Card.TYPE_VALS[type]:
			item_lists.back().add_item(item)
			item_lists.back().set_item_metadata(i, Card.new(type, item))
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
		popup_suggest_accuse_pressed.emit(Set.new(selected))
	
func _cancel_pressed():
	popup_suggest_accuse_pressed.emit(null)
