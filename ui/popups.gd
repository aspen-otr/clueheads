extends Control

enum PopupYN {YES, NO}
enum PopupSuggestAccuse {ACCUSATION, SUGGESTION}

func popup_yn(title_txt, yes_txt = PopupYN.keys()[PopupYN.YES], no_txt = PopupYN.keys()[PopupYN.NO]) -> PopupYN:
	return await %PopupYN.popup_yn(title_txt, yes_txt, no_txt)
	
func popup_suggest_accuse(guess_type_: PopupSuggestAccuse, locked_options: Array[Card] = []) -> Set:
	return await %PopupSuggestAccuse.popup_suggest_accuse(guess_type_, locked_options)
