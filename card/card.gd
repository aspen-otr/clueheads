extends Node
class_name Card

enum Type { SUSPECT, ROOM, WEAPON  }
const DEFAULT_TYPES: Array[Type] = [Type.SUSPECT, Type.ROOM, Type.WEAPON]

enum Suspect { MissScarlett, ColonelMustard, ProfessorPlum, MrGreen, MrsPeacock, DrOrchid }
enum Weapon { Revolver, Candlestick, Knife, Rope, LeadPipe, Wrench }
enum Room { Library, Kitchen, Conservatory, BilliardsRoom, Lounge, Ballroom, DiningRoom, Study, Hall }

const 	TYPE_VALS: Dictionary = {
	Type.SUSPECT: Suspect,
	Type.WEAPON: Weapon,
	Type.ROOM: Room
}

static var type_lut: Dictionary
static var suspect_lut: Dictionary
static var weapon_lut: Dictionary
static var room_lut: Dictionary

@export var type: Type
@export var image: Texture2D

var value

static func set_all_lut():
	for key in Type.keys():
		type_lut.set(Type[key], key)
	for key in Suspect.keys():
		suspect_lut.set(Suspect[key], key)
	for key in Weapon.keys():
		weapon_lut.set(Weapon[key], key)
	for key in Room.keys():
		room_lut.set(Room[key], key)

func pretty() -> String:
	var str_key
	if typeof(value) == TYPE_STRING:
		str_key = value
	elif type == Type.WEAPON:
		str_key = Weapon.keys()[value]
	elif type == Type.ROOM:
		str_key = Room.keys()[value]
	elif type == Type.SUSPECT:
		str_key = Suspect.keys()[value]
	return str_key.capitalize()

static func from_string(string: String) -> Card:
	for ty in Type.values():
		for key in TYPE_VALS[ty].keys():
			if key.capitalize() == string:
				return Card.new(ty, TYPE_VALS[ty][key])
	return null

func _init(type_: Type, value_):
	type = type_
	value = value_
