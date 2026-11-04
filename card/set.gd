extends Node
class_name Set

static var types: Array[Card.Type] = Card.DEFAULT_TYPES
var cards: Array[Card]

static func add_type(type: Card.Type):
	if type not in Set.types:
		Set.types.append(type)

static func remove_type(type: Card.Type):
	if type in Set.types:
		Set.types.remove_at(Set.types.find(type))

func has(card: Card) -> bool:
	return card in self.cards

func _init(cards_: Array[Card]):
	self.cards = cards_
	assert(len(self.cards) == len(Set.types))
	self.cards.sort_custom(func(x, y): return x.type < y.type)
