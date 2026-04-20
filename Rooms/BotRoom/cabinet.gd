extends Node2D

func _ready() -> void:
	
	App.events.cabinet_open.connect(func(): 
		var oscillator = preload("res://Items/oscillation_regulator.tscn").instantiate()
		add_child(oscillator)
		$Sprite2D.texture = preload("res://assets/images/cabinet_open.png")
	)
