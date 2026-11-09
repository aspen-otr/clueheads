class_name MainMenu
extends Control

@export var main_menu_buttons: MainMenuButtons
@export var lobby_buttons: LobbyButtons
@export var fade: Panel

func _ready() -> void:
	main_menu_buttons.multiplayer_button.pressed.connect(open_lobby_buttons)

func open_lobby_buttons() -> void:
	fade.visible = true
