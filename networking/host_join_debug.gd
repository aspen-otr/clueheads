# Proof of concept integration of network code and UI
extends Node

@export var return_text: Label
@export var text_input: TextEdit

func _ready() -> void:
	Lobby.player_connected.connect(on_player_connect)
	Lobby.player_disconnected.connect(on_player_disconnect)
	Lobby.server_disconnected.connect(on_server_disconnect)
	Lobby.connection_failed.connect(on_failed_connect)

	Lobby.client_chat_update.connect(update_label)

#region : Scene specific functions
# creates multiplayer lobby when the host button is pressed
# i was too lazy to add port-forwarding support but itd be very easy
func _on_host_button_pressed() -> void:
	var error = Lobby.create_game(null)
	if error:
		print(error)
		return

	Lobby.update_chat("Server Created", true)
	Lobby.update_chat("You are: Player 1")

# joins multiplayer lobby when join button is pressed
# defaults to Lobby's default address if an IP is not specified in the text_input node
func _on_join_button_pressed() -> void:
	var error = Lobby.join_game(text_input.text)
	if error:
		print(error)
		return

	Lobby.update_chat("Server Joined", true)

# leaves multiplayer lobby wehn leave button is pressed
func _on_leave_button_pressed() -> void:
	Lobby.remove_player()
	Lobby.update_chat("You have left the server", true)

# updates return_text node when a player's local chat data is updated
func update_label():
	return_text.text = Lobby.client_info.chat

#endregion

#region : lobby/UI integration
func on_player_connect(id: int) -> void:

	var data = Lobby.local_states
	var new_player: LocalGameState = data[id]

	# update's connected player's text telling them their player number
	Lobby.update_chat.rpc_id(id, str("You are: Player ", new_player.number))

	# update's existing player's text telling them that a new player has joined
	for i in data.keys():
		if i != id:
			Lobby.update_chat.rpc_id(i, str("Player ", new_player.number, " joined"))

func on_player_disconnect(id: int) -> void:
	var data = Lobby.dc_states
	var player: LocalGameState = data[id]

	Lobby.update_chat.rpc(str("Player ", player.number, " disconnected"))

func on_server_disconnect() -> void:
	Lobby.update_chat("Server disconnected")

func on_failed_connect() -> void:
	Lobby.update_chat("Connection failed")
#endregion
