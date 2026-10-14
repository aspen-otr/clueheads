extends Button

func _on_pressed() -> void:
	var result = await Popups.accept_deny("Testing")
	print(result)
	
