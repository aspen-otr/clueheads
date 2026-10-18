extends Node

@export var return_text: Label
@export var text_input: TextEdit

var client_data := {}

func _ready() -> void:
	Lobby.player_connected.connect(on_player_connect)
	Lobby.player_disconnected.connect(on_player_disconnect)
	Lobby.server_disconnected.connect(on_server_disconnect)


func _on_host_button_pressed() -> void:
	var error = await Lobby.create_game()
	if error:
		print(error)
		return
	client_data = Lobby.player_info
	update_label("Server created")
	update_label(str("You are: Player ", client_data["player number"]))

func _on_join_button_pressed() -> void:
	var error = await Lobby.join_game(text_input.text)
	if error:
		print(error)
		return
	#client_data = Lobby.player_info
	#update_label("Server joined")
	#update_label(str("You are: Player ", client_data["player number"]))

func on_player_connect(id: int, data: Dictionary) -> void:
	client_data = Lobby.player_info
	if id != client_data["id"]:
		printt(id, client_data["id"])
		update_label(str("Player ", data["player number"], " has joined"))
	else:
		update_label("Server joined")
		update_label(str("You are: Player ", client_data["player number"]))

func on_player_disconnect(id: int, data: Dictionary) -> void:
	if id != client_data["id"]:
		update_label(str("Player ", data["player number"], " has left"))

func on_server_disconnect() -> void:
	update_label("Lost connection to server")

func update_label(text: String, reset: bool = false):
	if reset:
		client_data["chat text"] = ""
	client_data["chat text"] += str(text, "\n")
	return_text.text = client_data["chat text"]
	Lobby.debug_data_display()
