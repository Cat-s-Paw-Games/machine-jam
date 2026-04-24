extends Node2D

func _ready():
	$BG.queue_free()
	
	
	App.events.switch_lights_on.connect(func(): 
		%Face.stop_loop()
		%Face.start_on_loop()
	)
	App.events.activate_generator.connect(func(): 
		%Console.stop_loop()
		%Console.start_on_loop()
	)

func _on_switch_pressed() -> void:
	if App.game_status.lights_on: return
	if App.in_focus: return
	
	App.ui.open_scene_in_focus(preload("res://Rooms/MainRoom/LightSwitchFocus.tscn").instantiate())
