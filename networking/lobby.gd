extends Node

signal player_connected(peer_id)
signal player_disconnected(peer_id)
signal server_disconnected()

const PORT: int = 7000
const DEFAULT_IP: String = "127.0.0.1" # IP defaults to local host
const MAX_CLIENTS: int = 6 # According to Clue rules

var local_data: Dictionary[int, PlayerData]
var player_info: PlayerData

func _ready():
	multiplayer.peer_connected.connect(on_player_connect)
	multiplayer.peer_disconnected.connect(on_player_disconnect)
	multiplayer.connected_to_server.connect(on_connect)
	multiplayer.connection_failed.connect(on_connection_fail)
	multiplayer.server_disconnected.connect(on_server_disconnect)

func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CLIENTS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	player_info = PlayerData.new()
	player_info.player_number = 1
	player_info.player_id = multiplayer.get_unique_id()
	local_data[1] = player_info

func join_game(address: String = ""):
	if address.is_empty():
		address = DEFAULT_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	player_info = PlayerData.new()
	player_info.player_number = local_data.size() + 1
	player_info.player_id = multiplayer.get_unique_id()
	local_data[player_info.player_number] = player_info

func remove_player():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()

func on_player_connect(id: int) -> void:
	player_connected.emit(id)

func on_player_disconnect(id: int) -> void:
	player_disconnected.emit(id)

func on_connect() -> void:
	pass

func on_connection_fail() -> void:
	pass

func on_server_disconnect() -> void:
	server_disconnected.emit()
