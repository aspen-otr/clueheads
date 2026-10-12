extends Node
class_name Card

enum Type { SUSPECT, ROOM, WEAPON  }

enum Suspect {}
enum Weapon {}
enum Room {}

@export var title: String
@export var type: Type
@export var image: Texture2D = null

@export var suspect: Suspect = null
@export var weapon: Weapon = null
@export var room: Room = null

func _init():
	match self.type:
		null:
			assert false # cannot have a null-type Card
		Type.SUSPECT:
			assert self.suspect != null
		Type.ROOM:
			assert self.room != null
		Type.WEAPON:
			assert self.weapon != null
