extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var all_choices = []
	for t in Card.TYPE_VALS.keys():
		for n in Card.TYPE_VALS[t].values():
			$UI/EnabledChoiceList.add_item(Card.new(t, n).pretty())
