class_name LobbyButtons
extends Control

signal back_pressed()
signal name_updated(new_name)

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

# allows main_menu to connect the same function to equivilant host/join nodes
func on_back_pressed() -> void:
	back_pressed.emit()

func on_name_updated(new_name) -> void:
	name_updated.emit(new_name)
