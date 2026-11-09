extends Node2D

var sections: Dictionary # Dictionary[String, Array[String]]
var items: Array[String] = []
var states: Array[State] = []
var ignore: Dictionary
@onready var list: ItemList = $Panel/ScrollContainer/ItemList as ItemList

enum State { UNKNOWN, MAYBE, NOT_GUILTY, CONFIRMED_GUILTY }
const ICONS = {
	State.UNKNOWN: preload("res://assets/blank.png"),
	State.MAYBE: preload("res://assets/qmark.png"),
	State.NOT_GUILTY: preload("res://assets/x.png"),
	State.CONFIRMED_GUILTY: preload("res://assets/circle.png")
}

func _init() -> void:
	sections = { "Rooms": ["Library", "Conservatory", "Kitchen"], "Weapons": ["Candlestick", "Revolver"], "Suspects": ["Miss Scarlett", "Colonel Mustard", "Dr. Orchid"] }
	items.clear()
	states.clear()
	for key in sections:
		items.append(key)
		ignore[key] = true
		items.append_array(sections[key])
	for index in range(len(items)):
		states.append(State.UNKNOWN)

func _ready() -> void:
	for item in items:
		if ignore.get(item, false):
			list.add_item(item, null, false)
		else:
			list.add_item(item, ICONS[State.UNKNOWN], false)
	list.item_clicked.connect(_handle_item_clicked)

func _handle_item_clicked(idx: int, _pos: Vector2, _mbi: int):
	states[idx] = (states[idx] + 1) % State.size() as State
	list.set_item_icon(idx, ICONS[states[idx]])
