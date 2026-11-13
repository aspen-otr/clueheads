class_name LobbyUI
extends Control

const DISPLAY_MODULE = preload("uid://2mrtcpc6dmkr")

@export var start_button: Button
@export var back_button: Button
@export var player_display: VBoxContainer

var displayed_players: Array[int]

#region : general functions
@rpc("call_local")
func display_player(given):
	Lobby.host_debug.rpc_id(1, str("Display player has been called with the argument: ", given))
	var player = LocalGameState.new()
	if given is LocalGameState:
		player = given
	else:
		player = LocalGameState.decode(given)
	
	print_debug(player.id)
	var new_module: PlayerDisplayModule = DISPLAY_MODULE.instantiate()
	player_display.add_child(new_module)
	new_module.peer_id = player.id
	new_module.player_name.set_text(player.name)
	new_module.player_number.set_text(str(player.number))

@rpc
func clear_player(id: int):
	for i in player_display.get_children():
		if i is PlayerDisplayModule:
			if i.peer_id == id:
				call_deferred("queue_free", i)

#endregion

#region : host functions
func _ready() -> void:
	Lobby.player_connected.connect(on_new_connection)

func on_new_connection(id: int) -> void:
	# new player catchup
	print_debug(Lobby.local_states)
	for i in Lobby.local_states:
		print_debug(i)
		print_debug(LocalGameState.encode(Lobby.local_states[i]))
		if i != id:
			display_player.rpc_id(id, LocalGameState.encode(Lobby.local_states[i]))
	# display new player
	var new_player_data = Lobby.local_states[id]
	display_player.rpc(LocalGameState.encode(new_player_data))

#endregion
