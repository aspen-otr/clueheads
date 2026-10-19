extends Node

@export var return_text: Label
@export var text_input: TextEdit

func _ready() -> void:
	Lobby.player_connected.connect(on_player_connect)
	Lobby.player_disconnected.connect(on_player_disconnect)
	Lobby.server_disconnected.connect(on_server_disconnect)
	
	Lobby.client_chat_update.connect(update_label)

func _on_host_button_pressed() -> void:
	var error = Lobby.create_game()
	if error:
		print(error)
		return
	
	Lobby.update_chat("Server Created")
	Lobby.update_chat("You are: Player 1")

func _on_join_button_pressed() -> void:
	var error = Lobby.join_game(text_input.text)
	if error:
		print(error)
		return
	
	Lobby.update_chat("Server Joined")

func on_player_connect(id: int) -> void:
	var data = Lobby.get_local_states()
	var new_player: LocalGameState = data[id]
	for i in data.keys():
		if i != id:
			Lobby.update_chat.rpc_id(i, str("Player ", new_player.number, " joined"))
		else:
			Lobby.update_chat.rpc_id(i, str("You are: Player ", new_player.number))

func on_player_disconnect(id: int) -> void:
	var data = Lobby.get_local_states()
	var player: LocalGameState = data[id]
	Lobby.update_chat.rpc(str("Player ", player.number, " disconnected"))

func on_server_disconnect() -> void:
	Lobby.update_chat("Server disconnected")

@rpc
func update_label():
	return_text.text = Lobby.client_info.chat
