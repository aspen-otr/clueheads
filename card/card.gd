extends Node
class_name Card

enum Type { SUSPECT, ROOM, WEAPON  }
const DEFAULT_TYPES: Array[Type] = [Type.SUSPECT, Type.ROOM, Type.WEAPON]

enum Suspect { MissScarlett, ColonelMustard, ProfessorPlum, MrGreen, MrsPeacock, DrOrchid }
enum Weapon { Revolver, Candlestick, Knife, Rope, LeadPipe, Wrench }
enum Room_type { Library, Kitchen, Conservatory, Billiard, Lounge, Ballroom, Dining, Study, Hall }

const 	TYPE_VALS: Dictionary = {
	Type.SUSPECT: Suspect,
	Type.WEAPON: Weapon,
	Type.ROOM: Room_type
}

static var suspect_lut: Array[String] = []
static var weapon_lut: Array[String] = []
static var room_lut: Array[String] = []

@export var type: Type
@export var image: Texture2D

var value

static func set_all_lut():
	suspect_lut.resize(Suspect.size())
	weapon_lut.resize(Weapon.size())
	room_lut.resize(Room_type.size())
	
	for key in Suspect.keys():
		suspect_lut[Suspect[key]] = key
	for key in Weapon.keys():
		weapon_lut[Weapon[key]] = key
	for key in Room_type.keys():
		room_lut[Room_type[key]] = key

func _init(type_: Type, value_):
	type = type_
	value = value_
