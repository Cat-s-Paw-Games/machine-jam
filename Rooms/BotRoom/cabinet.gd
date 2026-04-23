extends Node2D

func _ready() -> void:
	
	App.events.cabinet_open.connect(func():
		if App.game_status.cabinet_open:
			var tesseract = preload("res://Items/tesseract.tscn").instantiate()
			add_child(tesseract)
		else:
			App.game_status.cabinet_open = true
			var oscillator = preload("res://Items/oscillation_regulator.tscn").instantiate()
			add_child(oscillator)
			$Sprite2D.texture = preload("res://assets/images/cabinet_open.png")
	)
