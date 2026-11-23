extends Node

const FILEPATH = "res://networking/saved_data.txt"

var player_name:
	get: return data["Name"]
	set(val): 
		data["Name"] = val
		update_file()
var can_chat:
	get:
		var ret = data["Chat"]
		if typeof(ret) == TYPE_BOOL:
			return ret
		if ret == "true":
			return true
		elif ret == "false":
			return false
		else:
			return null
	set(val):
		data["Chat"] = val
		update_file()

var data := {
	"Name" : "",
	"Chat" : null,
}
var save: FileAccess

func _ready() -> void:
	save = FileAccess.open(FILEPATH, FileAccess.READ)
	while save.get_position() < save.get_length():
		var line = []
		line = save.get_line().split(" ")
		data[line[0]] = line[2]
	save.close()

func update_file() -> void:
	save = FileAccess.open(FILEPATH, FileAccess.WRITE)
	for i in data:
		save.store_line(str(i, " : ", data[i]))
	save.close()

func reset() -> void:
	player_name = ""
	can_chat = null
	
