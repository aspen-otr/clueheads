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

static var suspect_lut: Array[Suspect] = []
static var weapon_lut: Array[Weapon] = []
static var room_lut: Array[Room] = []

@export var type: Type
@export var image: Texture2D

var value

static func set_all_lut():
	for key in Suspect.keys():
		suspect_lut[Suspect[key]] = key
	for key in Weapon.keys():
		weapon_lut[Weapon[key]] = key
	for key in Room.keys():
		room_lut[Room[key]] = key

func _init(type_: Type, value_):
	type = type_
	value = value_
