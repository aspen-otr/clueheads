extends Window

func popup_info(title_txt, body_txt) -> void:
	%PopupInfo/Contents/TitleText.text = title_txt
	%PopupInfo/Contents/BodyText.text = body_txt
	%PopupInfo.popup()

func _on_ok_btn_pressed() -> void:
	%PopupInfo.hide()
