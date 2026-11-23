extends Control

enum PopupYN {YES, NO}
enum PopupSuggestAccuse {ACCUSATION, SUGGESTION}

func popup_info(title_txt, body_txt) -> void:
	%PopupInfo.popup_info(title_txt, body_txt)

func popup_yn(title_txt, yes_txt = PopupYN.keys()[PopupYN.YES], no_txt = PopupYN.keys()[PopupYN.NO]) -> PopupYN:
	return await %PopupYN.popup_yn(title_txt, yes_txt, no_txt)
	
func popup_suggest_accuse(guess_type_: PopupSuggestAccuse, locked_options: Array[Card] = []) -> Set:
	return await %PopupSuggestAccuse.popup_suggest_accuse(guess_type_, locked_options)

func popup_single_choice(choices: Array[Card]) -> Card:
	return await %PopupSC.get_single_choice(choices)
	
func enable_card_display(cards: Array[Card]) -> void:
	%CardDisplay.enable_card_display(cards)
	
func disable_card_display() -> void:
	%CardDisplay.disable_card_display()

# Optional convenience accessor for any screen using the shared Popups scene.
func popup_npc_setup(human_player_count: int = 1) -> Array[int]:
	return await %PopupNPCSetup.choose_npcs(human_player_count)
