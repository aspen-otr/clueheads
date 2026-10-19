extends Node

signal player_connected(peer_id)
signal player_disconnected(peer_id)
signal server_disconnected()

signal client_chat_update()

const PORT: int = 7000
const DEFAULT_IP: String = "127.0.0.1" # IP defaults to local host
const MAX_CLIENTS: int = 6 # According to Clue rules

var client_info: LocalGameState	
var master_data: MasterGameState

func _ready():
	multiplayer.peer_connected.connect(on_player_connect)
	multiplayer.peer_disconnected.connect(on_player_disconnect)
	multiplayer.connected_to_server.connect(on_connect)
	multiplayer.connection_failed.connect(on_connection_fail)
	multiplayer.server_disconnected.connect(on_server_disconnect)
	client_info = LocalGameState.new()

func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CLIENTS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	master_data = MasterGameState.new()
	client_info = LocalGameState.new()
	client_info.new_connect(1)
	master_data.client_data[client_info.id] = client_info

func join_game(address: String = ""):
	if address.is_empty():
		address = DEFAULT_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

func remove_player():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()

func on_player_connect(id: int) -> void:
	register_player.rpc_id(id)

@rpc("any_peer")
func register_player():
	var id = multiplayer.get_remote_sender_id()
	var new_data = LocalGameState.new()
	new_data.new_connect(id)
	master_data.client_data[id] = new_data
	set_client_data(JSON.stringify(new_data))
	player_connected.emit(id)
	

func on_player_disconnect(id: int) -> void:
	player_disconnected.emit(id)

func on_connect() -> void:
	pass

func on_connection_fail() -> void:
	pass

func on_server_disconnect() -> void:
	server_disconnected.emit()

@rpc
func set_client_data(data: String) -> bool:
	var new_data = JSON.parse_string(data)
	if new_data is not LocalGameState:
		return false
	return true

@rpc
func get_client_data() -> String:
	return JSON.stringify(client_info)

func get_local_states() -> Dictionary[int, LocalGameState]:
	return master_data.client_data

@rpc("call_local")
func update_chat(msg: String, reset: bool = false) -> void:
	if reset:
		client_info.chat = ""
	client_info.chat += str(msg, "\n")
	client_chat_update.emit()
