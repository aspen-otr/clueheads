extends Node
class_name Deck

var cards: Array[Card]
var case_file: Set

func reset_cards():
	for type in Set.types:
		for val in Card.TYPE_VALS[type]:
			cards.append(Card.new(type, val))

func gen_case_file():
	cards.clear()
	var selected: Array[Card]
	for type in Set.types:
		var tmp: Array[Card]
		for val in Card.TYPE_VALS[type]:
			tmp.append(Card.new(type, val))
		selected.append(tmp.pick_random())
		tmp.remove_at(tmp.find(selected.back()))
		cards.append_array(tmp)
	case_file = Set.new(selected)
	
func shuffle():
	cards.shuffle()
	
# total_players is the total quantity of players (including NPCs)
# target is the index (from 0) of the player that we are currently dealing to
func deal_to_player(total_players: int, target: int) -> Array[Card]:
	var player_hand: Array[Card]
	for i in range(cards.size()):
		if (i % total_players) == target:
			player_hand.append(cards[i])
	return player_hand

func _init():
	gen_case_file()
	shuffle()

	
