extends Control

func popup_suggest_accuse():
	_type_labels()
	_selection_menus()
	%PopupSuggestAccuse.popup()
	
func _type_labels():
	%PopupSuggestAccuse/Contents/Selections.columns = Set.types.size()
	for type in Set.types:
		var new_label = Label.new()
		new_label.text = Card.type_lut[type]
		%PopupSuggestAccuse/Contents/Selections.add_child(new_label)
		
func _selection_menus():
	for type in Set.types:
		var new_selection = ItemList.new()
		new_selection.auto_width = true
		new_selection.auto_height = true
		for item in Card.TYPE_VALS[type]:
			new_selection.add_item(item)
		%PopupSuggestAccuse/Contents/Selections.add_child(new_selection)
