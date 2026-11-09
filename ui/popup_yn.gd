extends Window

signal popup_yn_pressed

func popup_yn(title, yes_txt = Popups.PopupYN.keys()[Popups.PopupYN.YES], no_txt = Popups.PopupYN.keys()[Popups.PopupYN.NO]) -> Popups.PopupYN:
	%PopupYN/Contents/Text.text = title
	%PopupYN/Contents/Buttons/YesBtn.text = yes_txt
	%PopupYN/Contents/Buttons/NoBtn.text = no_txt
	%PopupYN.popup()
	var result = await popup_yn_pressed
	%PopupYN.hide()
	return result
	
func _yes_pressed() -> void:
	popup_yn_pressed.emit(Popups.PopupYN.YES)
	
func _no_pressed() -> void:
	popup_yn_pressed.emit(Popups.PopupYN.NO)
