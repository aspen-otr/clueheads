extends Node
class_name Card

enum Type { SUSPECT, ROOM, WEAPON  }

enum Suspect { MissScarlett, DrOrchid }
enum Weapon { Candlestick, Revolver }
enum Room { Library, Kitchen }

const TYPE_MAP: Dictionary[int, Variant] = { Type.SUSPECT: Suspect, Type.WEAPON: Weapon, Type.ROOM: Room }

@export var type: Type
@export var image: Texture2D

@export_group("Specific Properties")
@export var suspect: Suspect
@export var weapon: Weapon
@export var room: Room

func _init():
	pass
