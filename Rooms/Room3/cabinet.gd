extends Node2D

func _ready() -> void:
	App.events.cabinet_open.connect(func(): 
		var oscillator = preload("res://Items/oscillation_regulator.tscn").instantiate()
		add_child(oscillator)
		$Button.shape = null
		App.ui.close_scene_in_focus()
	)

func _on_button_pressed() -> void:
	App.ui.open_scene_in_focus(preload("res://Rooms/Room3/CabinetCode.tscn").instantiate())
