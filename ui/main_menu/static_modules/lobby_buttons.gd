class_name LobbyButtons
extends Control

signal back_pressed()

@export var host_parent: VBoxContainer
@export var host_name_input: LineEdit
@export var host_port_input: LineEdit
@export var host_game: Button
@export var host_back: Button

@export var join_parent: VBoxContainer
@export var join_name_input: LineEdit
@export var join_address_input: LineEdit
@export var join_port_input: LineEdit
@export var join_game: Button
@export var join_back: Button

# lets main_menu script connect the same function to both back buttons being pressed
func on_back_pressed() -> void:
	back_pressed.emit()
