extends Node

signal player_connected(peer_id, peer_data)
signal player_disconnected(peer_id, peer_data)
signal server_disconnected()

const PORT: int = 7000
const DEFAULT_IP: String = "127.0.0.1" # IP defaults to local host
const MAX_CLIENTS: int = 6 # According to Clue rules

var local_data: Dictionary[int, Dictionary]
var player_info := {}

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

	new_player_data()
	local_data[1] = player_info

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
	register_player.rpc_id(id, player_info)

@rpc("any_peer")
func register_player(new_player_info):
	var new_id = multiplayer.get_remote_sender_id()
	local_data[new_id] = new_player_info
	player_connected.emit(new_id, local_data[new_id])

func on_player_disconnect(id: int) -> void:
	player_disconnected.emit(id, local_data[id])

func on_connect() -> void:
	new_player_data()
	local_data[player_info["id"]] = player_info

func on_connection_fail() -> void:
	pass

func on_server_disconnect() -> void:
	server_disconnected.emit()

func new_player_data():
	player_info["player number"] = multiplayer.get_peers().size() + 1
	player_info["id"] = multiplayer.get_unique_id()
	player_info["chat text"] = ""

func debug_data_display():
	print(local_data)
