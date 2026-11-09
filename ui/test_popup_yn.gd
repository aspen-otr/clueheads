extends Button

func _on_pressed() -> void:
	var result = await Popups.popup_yn("Testing")
	print(Popups.PopupYN.keys()[result])
	
