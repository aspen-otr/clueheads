class_name LobbyButtons
extends Control

const JOIN_TEXT: String = "Join"
const LOAD_CHARS: Array[String] = [
	"ing.",
	"ing..",
	"ing...",
]
const JOIN_TIME: float = 0.66

signal back_pressed()

@export var host_parent: VBoxContainer
@export var host_port_input: LineEdit
@export var host_game: Button
@export var host_back: Button

@export var join_parent: VBoxContainer
@export var join_address_input: LineEdit
@export var join_port_input: LineEdit
@export var join_game: Button
@export var join_back: Button
@export var address_box: HBoxContainer
@export var port_box: HBoxContainer

var connecting: bool = false

# allows main_menu to connect the same function to equivilant host/join nodes
func on_back_pressed() -> void:
	back_pressed.emit()

func start_join_loading() -> void:
	connecting = true
	
	join_game.disabled = true
	join_back.visible = false
	address_box.visible = false
	port_box.visible = false
	
	# i could probably do this better but whatever
	var i = 0
	while connecting:
		join_game.set_text(str(JOIN_TEXT, LOAD_CHARS[i%3]))
		i += 1
		await get_tree().create_timer(JOIN_TIME).timeout

func stop_join_loading() -> void:
	connecting = false
	
	join_game.disabled = false
	join_back.visible = true
	address_box.visible = true
	port_box.visible = true
	
	join_game.set_text(JOIN_TEXT)
	
