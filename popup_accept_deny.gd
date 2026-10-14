extends Control

signal accept_deny_pressed

const accept_result = "Accept"
const deny_result = "Deny"

func accept_deny(title, accept_txt = accept_result, deny_txt = deny_result) -> String:
	%PopupAcceptDeny/Contents/Text.text = title
	%PopupAcceptDeny/Contents/Buttons/AcceptBtn.text = accept_txt
	%PopupAcceptDeny/Contents/Buttons/DenyBtn.text = deny_txt
	%PopupAcceptDeny.popup()
	var result = await accept_deny_pressed
	%PopupAcceptDeny.hide()
	return result
	
func _accept_pressed() -> void:
	accept_deny_pressed.emit(accept_result)
	
func _deny_pressed() -> void:
	accept_deny_pressed.emit(deny_result)
