extends Node2D
	

func _on_switch_pressed() -> void:
	if not App.game_status.lights_on: 
		App.ui.open_scene_in_focus(preload("res://Rooms/Room1/LightSwitchFocus.tscn").instantiate())
		

func _on_area_2d_mouse_entered() -> void:
	if not App.game_status.lights_on: App.mouse.hover_on($Switch)

func _on_area_2d_mouse_exited() -> void:
	if not App.game_status.lights_on: App.mouse.hover_out()
