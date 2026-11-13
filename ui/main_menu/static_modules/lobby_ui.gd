class_name LobbyUI
extends Control

signal close_lobby

const DISPLAY_MODULE = preload("uid://2mrtcpc6dmkr")

@export var start_button: Button
@export var back_button: Button
@export var player_display: VBoxContainer

var displayed_players: Array[int]

func _ready() -> void:
	# Host signal functions
	Lobby.player_connected.connect(on_new_connection)
	Lobby.player_disconnected.connect(on_client_disconnect)

	# Player signal functions
	Lobby.server_disconnected.connect(on_server_disconnect)

	# UI signal functions
	back_button.pressed.connect(close_lobby_ui)

#region : general functions
@rpc("call_local")
func display_player(given):
	Lobby.message_host(str("Display player has been called with the argument: ", given))
	var player = LocalGameState.new()
	if given is LocalGameState:
		player = given
	else:
		player = LocalGameState.decode(given)

	var new_module: PlayerDisplayModule = DISPLAY_MODULE.instantiate()
	player_display.add_child(new_module)
	new_module.peer_id = player.id
	new_module.player_name.set_text(player.name)
	new_module.player_number.set_text(str(player.number))

@rpc("call_local")
func clear_player(id: int):
	Lobby.message_host(str("Player ID: ", id, "has been cleared"))
	for i in player_display.get_children():
		if i is PlayerDisplayModule:
			if i.peer_id == id:
				i.call_deferred("queue_free")

func clear_all_players():
	for i in player_display.get_children():
		if i is PlayerDisplayModule:
			i.call_deferred("queue_free")

func close_lobby_ui():
	close_lobby.emit()

#endregion

#region : host functions
func on_new_connection(id: int) -> void:
	# new player catchup
	for i in Lobby.local_states:
		if i != id:
			display_player.rpc_id(id, LocalGameState.encode(Lobby.local_states[i]))
	# display new player
	var new_player_data = Lobby.local_states[id]
	display_player.rpc(LocalGameState.encode(new_player_data))

func on_client_disconnect(id: int) -> void:
	clear_player.rpc(id)

#endregion

#region : client functions
func on_server_disconnect() -> void:
	clear_all_players()
	close_lobby_ui()
#endregion
