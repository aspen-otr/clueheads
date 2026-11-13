class_name MainMenu
extends Control

# i scrapped what i was originally going to do with these
# but they might be useful later, so i'm keeping them
enum display {MAIN, HOST, JOIN, LOBBY, OPTIONS}
var current_display

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

	current_display = display.MAIN

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if lobby_buttons.visible:
			close_lobby_buttons()

#region : ui display
func open_host() -> void:
	fade.visible = true
	lobby_buttons.visible = true
	lobby_buttons.host_parent.visible = true

	current_display = display.HOST

func open_join() -> void:
	fade.visible = true
	lobby_buttons.visible = true
	lobby_buttons.join_parent.visible = true

	current_display = display.JOIN

func open_options() -> void:
	push_error("Unimplemented")

func close_lobby_buttons() -> void:
	fade.visible = false
	lobby_buttons.visible = false
	lobby_buttons.host_parent.visible = false
	lobby_buttons.join_parent.visible = false

	current_display = display.MAIN

func open_lobby() -> void:
	close_lobby_buttons()
	main_menu_buttons.visible = false
	lobby_ui.visible = true

	current_display = display.LOBBY

func close_lobby() -> void:
	lobby_ui.visible = false
	main_menu_buttons.visible = true

	current_display = display.MAIN

#endregion

#region : game logic
func launch_singleplayer() -> void:
	push_error("Unimplemented")

func host_lobby() -> void:
	var port = lobby_buttons.host_port_input.text
	if port:
		if typeof(port) != Variant.Type.TYPE_INT:
			printerr("Invalid port")
			lobby_buttons.host_port_input.clear()
			return

	var error = Lobby.create_game(port)

	if error:
		printerr(error)
		return
	else:
		open_lobby()
		lobby_ui.start_button.disabled = false

		var player_name = lobby_buttons.host_name_input.text
		if !player_name:
			player_name = "Player"
		Lobby.client_name = player_name
		print_debug("running host display")
		lobby_ui.display_player(Lobby.client_info)


func join_lobby() -> void:
	var port = lobby_buttons.join_port_input.text
	var address = lobby_buttons.join_address_input.text
	if port:
		if typeof(port) != Variant.Type.TYPE_INT:
			printerr("Invalid port")
			lobby_buttons.host_port_input.clear()
			return

	var error = Lobby.join_game(address, port)

	if error:
		printerr(error)
		return
	else:
		open_lobby()

	var player_name = lobby_buttons.join_name_input.text
	if !player_name:
		player_name = "Player"
	Lobby.client_name = player_name

func leave_lobby() -> void:
	Lobby.remove_player()
	close_lobby()

func quit_game() -> void:
	get_tree().quit()

#endregion
