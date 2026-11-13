#TODO: authentication
extends Node

signal lobby_created()
signal player_connected(peer_id)
signal player_disconnected(peer_id)
signal server_disconnected()
signal connection_failed()

signal client_chat_update()

# TEMP : local ip for testing LAN hosting
const DEFAULT_IP: String = "192.168.1.88"

const PORT: int = 7000
#const DEFAULT_IP: String = "127.0.0.1" # IP defaults to local host
const MAX_CLIENTS: int = 6 # According to Clue rules

# Player's game state data
var client_info: LocalGameState
var client_name: String

var registered: bool = false

# Host's authoritative data. Not initialized on non-host clients
var master_data: MasterGameState
# master_data list of local game states of all currently connected players
var local_states: Dictionary[int, LocalGameState]:
	get:
		return master_data.client_data
# master_data list of local game states of any disconnected players
var dc_states: Dictionary[int, LocalGameState]:
	get:
		return master_data.disconnected_data

func _ready():
	multiplayer.peer_connected.connect(on_player_connect)
	multiplayer.peer_disconnected.connect(on_player_disconnect)
	multiplayer.connected_to_server.connect(on_connect)
	multiplayer.connection_failed.connect(on_connection_fail)
	multiplayer.server_disconnected.connect(on_server_disconnect)

	client_info = LocalGameState.new()

#region : Scene specific functions
func create_game(given_port):
	if !given_port:
		given_port = PORT
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(given_port, MAX_CLIENTS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	master_data = MasterGameState.new()
	client_info = LocalGameState.new()
	client_info.new_connect(1)
	master_data.client_data[client_info.id] = client_info

	lobby_created.emit()
	registered = true

func join_game(address: String = "", given_port = null):
	if address.is_empty():
		address = DEFAULT_IP
	if !given_port:
		given_port = PORT

	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

func remove_player():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()

# creates a local game state object and adds it to the host's master data
@rpc("any_peer")
func register_player():
	var id = multiplayer.get_remote_sender_id()
	var new_data = LocalGameState.new()
	new_data.new_connect(id)
	master_data.client_data[id] = new_data
	set_client_data.rpc_id(id, LocalGameState.encode(new_data))

	player_connected.emit(id)
	print_debug("Informing client they are registered")
	set_ready.rpc_id(id)
	print_debug(local_states)

#region : RPCs
# functions that can be called on specific clients

# sets a client's local game state
@rpc
func set_client_data(data: Dictionary):
	client_info = LocalGameState.decode(data)

# updates host's master list of game states based on client's current local game state
@rpc("call_local")
func get_client_data() -> void:
	update_local_data.rpc_id(1, LocalGameState.encode(client_info))
@rpc("call_local", "any_peer")
func update_local_data(data: Dictionary):
	var id = multiplayer.get_remote_sender_id()
	local_states[id] = LocalGameState.decode(data)

# updates a client's local_data chat string
@rpc("call_local")
func update_chat(msg: String, reset: bool = false) -> void:
	if reset:
		client_info.chat = ""
	client_info.chat += str(msg, "\n")
	client_chat_update.emit()

func message_host(message: String):
	if !multiplayer.is_server():
		msg_rpc.rpc_id(1, message)
	else:
		print_debug(str("Message sent to self: ", message))
@rpc("any_peer", "call_local")
func msg_rpc(message: String):
	print()
	prints("Client", multiplayer.get_remote_sender_id(), "has sent message:")
	print(message)
	print()

@rpc
func set_ready() -> void:
	registered = true

@rpc
func get_ready() -> bool:
	return registered

#endregion
#endregion

#region : Signal connected functions
func on_player_connect(_id) -> void:
	print_debug("Player connected")

func on_player_disconnect(id: int) -> void:
	print_debug("Player disconnected")
	dc_states[id] = local_states[id]
	master_data.client_data.erase(id)
	player_disconnected.emit(id)

func on_connect() -> void:
	message_host("I have connected")
	register_player.rpc_id(1)

func on_connection_fail() -> void:
	connection_failed.emit()

func on_server_disconnect() -> void:
	server_disconnected.emit()
#endregion
