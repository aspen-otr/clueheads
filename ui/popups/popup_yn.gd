extends Control

signal popup_yn_pressed

enum PopupYN {YES, NO}

func popup_yn(title, yes_txt = PopupYN.keys()[PopupYN.YES], no_txt = PopupYN.keys()[PopupYN.NO]) -> PopupYN:
	%PopupYN/Contents/Text.text = title
	%PopupYN/Contents/Buttons/YesBtn.text = yes_txt
	%PopupYN/Contents/Buttons/NoBtn.text = no_txt
	%PopupYN.popup()
	var result = await popup_yn_pressed
	%PopupYN.hide()
	return result
	
func _yes_pressed() -> void:
	popup_yn_pressed.emit(PopupYN.YES)
	
func _no_pressed() -> void:
	popup_yn_pressed.emit(PopupYN.NO)
