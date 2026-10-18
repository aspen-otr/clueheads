extends Node

@export var return_text: Label
@export var text_input: TextEdit

var local_data = PlayerData

func _ready() -> void:
	Lobby.player_connected.connect(on_player_connect)
	Lobby.player_disconnected.connect(on_player_disconnect)
	Lobby.server_disconnected.connect(on_server_disconnect)


func _on_host_button_pressed() -> void:
	var error = await Lobby.create_game()
	if error:
		print(error)
		return
	local_data = Lobby.player_info
	update_label("Server created", true)

func _on_join_button_pressed() -> void:
	var error = await Lobby.join_game(text_input.text)
	if error:
		print(error)
		return
	local_data = Lobby.player_info
	update_label("Server joined", true)

func on_player_connect(id: int) -> void:
	update_label(str("Player ", id, " has joined"))

func on_player_disconnect(id: int) -> void:
	update_label(str("Player ", id, " has left"))

func on_server_disconnect() -> void:
	update_label("Lost connection to server")

@rpc
func update_label(text: String, reset: bool = false):
	if reset:
		local_data.chat_text = ""
	local_data.chat_text += str(text, "\n")
	return_text.text = local_data.chat_text
