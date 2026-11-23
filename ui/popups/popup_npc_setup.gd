class_name PopupNPCSetup
extends Window

# This popup configures NPC counts and behaviors; it does not implement NPC AI.
# A returned 0 means Random NPC, and 1 means Strategic NPC.
enum NPCBehavior { RANDOM, STRATEGIC }

signal selection_finished(npc_behaviors: Array[int])

const MAX_TOTAL_PLAYERS: int = 6
const MAX_NPCS: int = 5

@onready var npc_count: SpinBox = $Panel/Margin/Contents/CountRow/NpcCount
@onready var player_count_text: Label = $Panel/Margin/Contents/PlayerCount
@onready var npc_rows: VBoxContainer = $Panel/Margin/Contents/NpcRows
@onready var confirm_button: Button = $Panel/Margin/Contents/Buttons/ConfirmButton
@onready var cancel_button: Button = $Panel/Margin/Contents/Buttons/CancelButton

var _human_players: int = 1


func _ready() -> void:
	npc_count.value_changed.connect(_on_npc_count_changed)
	confirm_button.pressed.connect(_confirm)
	cancel_button.pressed.connect(_cancel)
	close_requested.connect(_cancel)
	_rebuild_rows()


# Returns an empty Array[int] if the user cancels.
# This API also works in a lobby: pass the number of human players there.
func choose_npcs(human_player_count: int = 1) -> Array[int]:
	if human_player_count < 1 or human_player_count > MAX_TOTAL_PLAYERS - 1:
		push_warning("NPC setup needs between 1 and 5 human players, so at least 1 NPC can fit.")
		return []

	_human_players = human_player_count
	npc_count.min_value = 1
	npc_count.max_value = mini(MAX_NPCS, MAX_TOTAL_PLAYERS - _human_players)
	npc_count.value = 1
	_rebuild_rows()
	popup_centered()
	return await selection_finished


func _on_npc_count_changed(_new_value: float) -> void:
	_rebuild_rows()


func _rebuild_rows() -> void:
	# Keep already-selected AI types when the player changes the count.
	var previous_modes: Array[int] = []
	for row in npc_rows.get_children():
		var dropdown: OptionButton = row.get_node("Behavior")
		previous_modes.append(dropdown.get_selected_id())
		npc_rows.remove_child(row)
		row.queue_free()

	var count: int = int(npc_count.value)
	for i in range(count):
		var row := HBoxContainer.new()
		row.name = "NPC%d" % (i + 1)
		row.add_theme_constant_override("separation", 12)

		var title := Label.new()
		title.text = "NPC %d" % (i + 1)
		title.custom_minimum_size.x = 145
		row.add_child(title)

		var dropdown := OptionButton.new()
		dropdown.name = "Behavior"
		dropdown.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		dropdown.add_item("Random NPC", NPCBehavior.RANDOM)
		dropdown.add_item("Strategic NPC", NPCBehavior.STRATEGIC)
		dropdown.select(0)
		if i < previous_modes.size():
			dropdown.select(previous_modes[i])
		row.add_child(dropdown)
		npc_rows.add_child(row)

	var total: int = _human_players + count
	player_count_text.text = "Players: %d human + %d NPC = %d / %d total" % [
		_human_players, count, total, MAX_TOTAL_PLAYERS
	]
	confirm_button.disabled = count < 1 or count > MAX_NPCS or total > MAX_TOTAL_PLAYERS


func _confirm() -> void:
	var selected: Array[int] = []
	for row in npc_rows.get_children():
		var dropdown: OptionButton = row.get_node("Behavior")
		selected.append(dropdown.get_selected_id())

	if selected.is_empty() or selected.size() > MAX_NPCS:
		return
	if _human_players + selected.size() > MAX_TOTAL_PLAYERS:
		return

	hide()
	selection_finished.emit(selected)


func _cancel() -> void:
	hide()
	var none: Array[int] = []
	selection_finished.emit(none)
