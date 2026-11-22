extends Button

func _on_pressed() -> void:
	var value = await Popups.popup_yn("Testing Title")
	print(Popups.PopupYN.keys()[value])
