extends Control

var cards: Array[Card]

func enable_card_display(cards_: Array[Card]) -> void:
	cards = cards_
	_reset_card_txt()
	_show_cards()
	visible = true
	
func disable_card_display() -> void:
	visible = false

func _reset_card_txt() -> void:
	var card_txt: String = ""
	for card in cards:
		card_txt = card_txt + card.pretty() + "\n"
	$CardHand/Cards/CardTxt.text = card_txt
	
func _show_cards() -> void:
	$ShowCardsBtn.visible = false
	$CardHand.visible = true

func _hide_cards() -> void:
	$CardHand.visible = false
	$ShowCardsBtn.visible = true
