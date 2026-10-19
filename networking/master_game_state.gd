class_name MasterGameState
extends Resource

var client_data: Dictionary[int, LocalGameState]

# not implemented yet
var board_state
var cards: Dictionary[int, Array]
var case_cards: Array

func validate(id: int) -> bool:
	var client = client_data[id]
	
	if client.cards != cards[id]:
		printerr("player ", client.number, " hand invalid")
		return false
	
	# not implemented
	if client.board_state != board_state:
		pass
	
	return true
