extends Node

@export var return_text: Label

func _ready() -> void:
	Lobby.player_connected.connect(on_player_connect)
	Lobby.player_disconnected.connect(on_player_disconnect)
	Lobby.server_disconnected.connect(on_server_disconnect)

func _on_host_button_pressed() -> void:
	var error = Lobby.create_game()
	if error: 
		print(error)
		return
	update_label("Server created")

func _on_join_button_pressed() -> void:
	var error = Lobby.join_game()
	if error: 
		print(error)
		return
	update_label("Server joined")
	
func on_player_connect(id: int) -> void:
	update_label(str("Player ", id, " has joined"))

func on_player_disconnect(id: int) -> void:
	update_label(str("Player ", id, " has left"))

func on_server_disconnect() -> void:
	update_label("Lost connection to server")

@rpc
func update_label(text: String, reset: bool = false):
	if reset:
		return_text.text = ""
	return_text.text += str(text, "\n")
