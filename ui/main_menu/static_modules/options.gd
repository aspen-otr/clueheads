class_name Options
extends Control

@export var back_button: Button
@export var reset_data_button: Button

func _ready() -> void:
	reset_data_button.pressed.connect(reset_data)

func reset_data() -> void:
	SavedData.reset()
	Popups.popup_info("Save data reset", "")
