extends Control

const accept_result = "Accept"
const deny_result = "Deny"

func show_popup_accept_deny(title, accept_txt = accept_result, deny_txt = deny_result) -> void:
	%PopupAcceptDeny/Contents/Text.text = title
	%PopupAcceptDeny/Contents/Buttons/AcceptBtn.text = accept_txt
	%PopupAcceptDeny/Contents/Buttons/DenyBtn.text = deny_txt
	%PopupAcceptDeny.popup()
	
func _opt_pressed(result) -> String:
	%PopupAcceptDeny.hide()
	print(result)
	return result
	
func _accept_pressed() -> String:
	return _opt_pressed(accept_result)
	
func _deny_pressed() -> String:
	return _opt_pressed(deny_result)
