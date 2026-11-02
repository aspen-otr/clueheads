extends Button

func _on_pressed() -> void:
	Card.set_all_lut()
	Popups.popup_suggest_accuse()
	
