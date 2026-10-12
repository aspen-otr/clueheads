extends Node
class_name Card

enum Type { SUSPECT, ROOM, WEAPON  }

enum Suspect { MissScarlett, ColonelMustard, ProfessorPlum, MrGreen }
enum Weapon { Revolver, Candlestick }
enum Room { Library, Kitchen, Conservatory, BilliardsRoom }

@export var type: Type
@export var image: Texture2D

@export var suspect: Suspect
@export var weapon: Weapon
@export var room: Room

func _init():
	pass
