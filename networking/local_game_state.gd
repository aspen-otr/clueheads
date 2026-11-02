class_name LocalGameState
extends Resource

var name: String
var number: int
var id: int
var chat: String

#TODO: update
var board_state
var hand: Array
var detective_sheet

func new_connect(new_id: int, new_name: String = "Player") -> void:
	name = new_name
	id = new_id
	
	number = Lobby.local_states.size() + 1

# translates resource to/from a dictionary for JSON purposes
func encode() -> Dictionary:
	return {
		"name" : name,
		"number" : number,
		"id" : id,
	}
func decode(data: Dictionary) -> void:
	name = data["name"]
	number = data["number"]
	id = data["id"]
