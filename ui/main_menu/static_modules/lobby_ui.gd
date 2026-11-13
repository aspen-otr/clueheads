class_name LobbyUI
extends Control

signal close_lobby

const DISPLAY_MODULE = preload("uid://2mrtcpc6dmkr")

@export var start_button: Button
@export var back_button: Button
@export var ready_button: Button
@export var player_display: VBoxContainer

@export var chat_display: RichTextLabel
@export var chat_input: LineEdit

var player_ready: Dictionary[int, bool]

func _ready() -> void:
	# misc signal functions
	Lobby.client_chat_update.connect(update_chat_log)

	# Host signal functions
	Lobby.player_connected.connect(on_new_connection)
	Lobby.player_disconnected.connect(on_client_disconnect)

	# Player signal functions
	Lobby.server_disconnected.connect(on_server_disconnect)

	# UI signal functions
	back_button.pressed.connect(close_lobby_ui)
	chat_input.text_submitted.connect(send_msg)
	ready_button.toggled.connect(set_ready)

#region : general functions

func lobby_open() -> void:
	if multiplayer.is_server():
		ready_button.visible = false
		player_ready[1] = true
		display_player(Lobby.client_info)
		display_ready(player_ready)
	else:
		ready_button.visible = true
	update_chat_log()

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
	clear_all_players()
	Lobby.update_chat("", true)
	player_ready.clear()
	ready_button.button_pressed = false
	close_lobby.emit()

@rpc
func update_chat_log():
	chat_display.set_text(Lobby.client_info.chat)

func send_msg(new_message):
	Lobby.update_chat.rpc(str(" - (", Lobby.client_info.number, ") ", Lobby.client_name, ": ", new_message))
	chat_input.clear()

@rpc("call_local")
func display_ready(states: Dictionary[int, bool]):
	for i in player_display.get_children():
		if i is PlayerDisplayModule:
			if states[i.peer_id]:
				i.ready_status.button_pressed = true
			else:
				i.ready_status.button_pressed = false

#endregion

#region : host functions
func on_new_connection(id: int) -> void:
	# new player catchup
	Lobby.update_chat.rpc_id(id, "Connection Successful")
	for i in Lobby.local_states:
		if i != id:
			display_player.rpc_id(id, LocalGameState.encode(Lobby.local_states[i]))
	# display new player
	var new_player_data = Lobby.local_states[id]
	display_player.rpc(LocalGameState.encode(new_player_data))
	for i in Lobby.local_states:
		if i != id:
			Lobby.update_chat.rpc_id(i, str("(", new_player_data.number, ") ", new_player_data.name, " has joined the lobby"))
	player_ready[id] = false
	check_ready()
	display_ready.rpc_id(id, player_ready)

func on_client_disconnect(id: int) -> void:
	clear_player.rpc(id)
	var dc_data = Lobby.dc_states[id]
	Lobby.update_chat(str("(", dc_data.number, ") ", dc_data.name, " has left the lobby"))
	player_ready.erase(id)
	check_ready()

@rpc("any_peer")
func update_ready(new_state: bool) -> void:
	var id = multiplayer.get_remote_sender_id()
	player_ready[id] = new_state
	check_ready()
	display_ready.rpc(player_ready)

func check_ready() -> void:
	print_debug("checking ready")
	if player_ready.size() > 1:
		if !player_ready.values().has(false):
			start_button.disabled = false
			return
	start_button.disabled = true

#endregion

#region : client functions
func on_server_disconnect() -> void:
	clear_all_players()
	close_lobby_ui()

func set_ready(new_state: bool):
	update_ready.rpc_id(1, new_state)

#endregion
