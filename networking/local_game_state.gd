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

func new_connect(new_id: int, new_name: String) -> void:
	name = new_name
	id = new_id

	number = Lobby.local_states.size() + 1

# translates resource to/from a dictionary for JSON purposes
static func encode(dict) -> Dictionary:
	return {
		"name" : dict.name,
		"number" : dict.number,
		"id" : dict.id,
	}

static func decode(data: Dictionary) -> LocalGameState:
	var new_state = LocalGameState.new()
	new_state.name = data["name"]
	new_state.number = data["number"]
	new_state.id = data["id"]
	return new_state
