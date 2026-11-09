extends Window
class_name PopupSingleChoice

signal single_choice_made(card_picked)
var choices: Array[Card] = []

func _ready():
	clear()
	%PopupSC.hide()
	%PopupSC/Contents/ItemList.auto_width = true
	%PopupSC/Contents/ItemList.auto_height = true

	%PopupSC/Contents/ItemList.item_clicked.connect(_item_clicked)
	%PopupSC/Contents/Submit.button_down.connect(_submit_clicked)

func get_single_choice(choices_: Array[Card]) -> Card:
	clear()
	add_choices(choices_)
	return await get_choice()

func add_choices(extra: Array[Card]):
	choices.append_array(extra)

func clear():
	choices.clear()

func get_choice():
	var il = %PopupSC/Contents/ItemList as ItemList
	var btn = %PopupSC/Contents/Submit as Button
	if choices.is_empty():
		il.hide()
	il.clear()
	for choice in choices:
		il.add_item(choice.pretty(), null, true)
	btn.disabled = !choices.is_empty()
	%PopupSC.popup()
	var response = await single_choice_made
	%PopupSC.hide()
	return response

func _submit_clicked():
	var list = %PopupSC/Contents/ItemList
	var sel = list.get_selected_items()
	if sel.is_empty():
		single_choice_made.emit(null)
		return
	var card = Card.from_string(list.get_item_text(sel[0]))
	single_choice_made.emit(card)

func _item_clicked(_index: int, _a: Vector2, _b: int):
	var btn = %PopupSC/Contents/Submit
	btn.disabled = false
