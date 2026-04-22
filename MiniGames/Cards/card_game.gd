extends Node2D

signal won

const CARD = preload("uid://cbu7w8oycwwvu")
@onready var pivot: Node2D = %Pivot

@export var grid_size = Vector2(3,6)
var cell_size = 110 #128

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
	cards.shuffle()
	var counter = 0
	for y in grid_size.y:
		for x in grid_size.x:
			var card = cards[counter]
			card.position = Vector2(x *  (128 / 2 + 10),y * (200 / 2 + 10)  )
			card.selected.connect(_on_card_selected)
			pivot.add_child(card)
			counter += 1

func check_win_condition():
	if matches_found.size() >= (grid_size.x * grid_size.y) / 2:
		won.emit()

func _on_card_selected(card : Card):
	if current_card == null:
		current_card = card
	elif current_card == card:
		pass
	elif current_card.match_id == card.match_id:
		current_card.match_found()
		card.match_found()
		current_card = null
		matches_found.append(card.match_id)
		check_win_condition()
	else:
		App.game_status.flipping_cards = true
		await get_tree().create_timer(1).timeout
		App.game_status.flipping_cards = false
		current_card.flip()
		card.flip()
		current_card = null
		
