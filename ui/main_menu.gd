class_name MainMenu
extends Control

@export var main_menu_buttons: MainMenuButtons
@export var lobby_buttons: LobbyButtons
@export var lobby_ui: LobbyUI
@export var fade: Panel

func _ready() -> void:
	main_menu_buttons.host_button.pressed.connect(open_host)
	main_menu_buttons.join_button.pressed.connect(open_join)
	main_menu_buttons.quit_button.pressed.connect(quit_game)
	main_menu_buttons.singleplayer_button.pressed.connect(launch_singleplayer)
	main_menu_buttons.options_button.pressed.connect(open_options)
	
	lobby_buttons.back_pressed.connect(close_lobby_buttons)
	lobby_buttons.host_game.pressed.connect(host_lobby)
	lobby_buttons.join_game.pressed.connect(join_lobby)
	
	lobby_ui.back_button.pressed.connect(leave_lobby)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if lobby_buttons.visible:
			close_lobby_buttons()

#region : ui display
func open_host() -> void:
	fade.visible = true
	lobby_buttons.visible = true
	lobby_buttons.host_parent.visible = true

func open_join() -> void:
	fade.visible = true
	lobby_buttons.visible = true
	lobby_buttons.join_parent.visible = true

func open_options() -> void:
	push_error("Unimplemented")

func close_lobby_buttons() -> void:
	fade.visible = false
	lobby_buttons.visible = false
	lobby_buttons.host_parent.visible = false
	lobby_buttons.join_parent.visible = false

func open_lobby() -> void:
	close_lobby_buttons()
	main_menu_buttons.visible = false
	lobby_ui.visible = true

func close_lobby() -> void:
	lobby_ui.visible = false
	main_menu_buttons.visible = true
	
#endregion

#region : game logic
func launch_singleplayer() -> void:
	push_error("Unimplemented")

func host_lobby() -> void:
	var error = Lobby.create_game(lobby_buttons.host_port_input.text)
	if error:
		printerr(error)
		return
	else:
		open_lobby()
	
func join_lobby() -> void:
	pass

func leave_lobby() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	close_lobby()

func quit_game() -> void:
	get_tree().quit()
	
#endregion
