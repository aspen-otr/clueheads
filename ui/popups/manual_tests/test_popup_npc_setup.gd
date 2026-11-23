extends Control

@onready var popup: PopupNPCSetup = $PopupNPCSetup
@onready var result_label: Label = $VBox/Result


func _ready() -> void:
	$VBox/SingleplayerButton.pressed.connect(_test_singleplayer)
	$VBox/ThreeHumanButton.pressed.connect(_test_three_humans)


func _test_singleplayer() -> void:
	await _show_setup(1)


func _test_three_humans() -> void:
	await _show_setup(3)


func _show_setup(humans: int) -> void:
	var modes: Array[int] = await popup.choose_npcs(humans)
	if modes.is_empty():
		result_label.text = "Cancelled"
		return

	var labels: Array[String] = []
	for mode in modes:
		labels.append("Strategic" if mode == PopupNPCSetup.NPCBehavior.STRATEGIC else "Random")
	result_label.text = "%d human(s), %d NPC(s): %s" % [humans, modes.size(), ", ".join(labels)]
