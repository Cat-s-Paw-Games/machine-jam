extends Node2D

const CARD = preload("uid://cbu7w8oycwwvu")
@onready var pivot: Node2D = %Pivot

var grid_size = Vector2(6,6)
var cell_size = 128

var cards = []
var current_card = null
var matches_found = []

func _ready() -> void:
	create_card_pairs()
	populate_grid()

func create_card_pairs():
	var counter = 0
	for x in grid_size.x * grid_size.y / 2:
		for i in range(2):
			var card = CARD.instantiate()
			card.match_id = counter
			cards.append(card)
		counter += 1

func populate_grid():
	var counter = 0
	for y in grid_size.y:
		for x in grid_size.x:
			var card = cards[counter]
			card.position = cell_size * Vector2(x,y)
			card.selected.connect(_on_card_selected)
			pivot.add_child(card)
			counter += 1

func check_win_condition():
	if matches_found.size() >= (grid_size.x * grid_size.y) / 2:
		print("win")
		print(matches_found)

func _on_card_selected(card : Card):
	if current_card == null:
		current_card = card
	elif current_card == card:
		current_card = null
	elif current_card.match_id == card.match_id:
		current_card.match_found()
		card.match_found()
		current_card = null
		matches_found.append(card.match_id)
		check_win_condition()
	else:
		current_card.flip()
		card.flip()
		current_card = null
