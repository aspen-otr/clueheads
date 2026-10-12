class_name Set

const Card = preload("res://card.gd")

# A set of cards (classically, a Weapon/Suspect/Room combination)
# that forms the basis of a Suggestion or Accusation

static var types: Array[Card.Type] = [Card.Type.SUSPECT, Card.Type.WEAPON, Card.Type.ROOM] # Can be added to in future.
var values: Array[Card]

func equal_to(other: Set) -> bool:
	self.types

# Convenience: we can pass any order to this and it sorts it accordingly.
static func try_assign(values_: Array[Card]) -> Array[Card]:
	var values: Array[Card] = []
	if len(values_) != len(Set.types):
		return null
	for val_ in values_:
		for i in range(len(Set.types)):
			if Set.types[i] == val_.type:
				if values[i] != null:
					return null
				values[i] = val_
				break
	return values

func _init(values_: Array[Card]):
	self.values = Set.try_assign(values_)
	assert self.values != null
