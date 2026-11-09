class_name MasterGameState
extends Resource

var client_data: Dictionary[int, LocalGameState]
var disconnected_data: Dictionary[int, LocalGameState]

#TODO: update
var board_state
var cards: Dictionary[int, Array]
var case_cards: Array

#TODO: data validation
