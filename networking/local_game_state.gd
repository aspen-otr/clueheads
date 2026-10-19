class_name LocalGameState
extends Resource

var name: String
var number: int
var id: int
var chat: String

# not implemented yet
var board_state
var hand: Array
var detective_sheet

func new_connect(new_id: int, new_name: String = "Player") -> void:
	name = new_name
	id = new_id
	
	number = Lobby.get_local_states().size() + 1
