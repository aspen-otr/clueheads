class_name Dice
extends RefCounted

const DEFAULT_DICE_COUNT: int = 2
const DEFAULT_SIDES: int = 6

var dice_count: int
var sides: int


func _init(dice_count_: int = DEFAULT_DICE_COUNT, sides_: int = DEFAULT_SIDES) -> void:
	assert(dice_count_ > 0, "Dice count must be greater than zero.")
	assert(sides_ > 1, "A die must have at least two sides.")
	dice_count = dice_count_
	sides = sides_


func roll() -> Array[int]:
	var results: Array[int] = []
	for _die in range(dice_count):
		results.append(randi_range(1, sides))
	return results


func total(results: Array[int]) -> int:
	var sum: int = 0
	for result in results:
		sum += result
	return sum
