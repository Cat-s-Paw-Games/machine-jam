extends Node2D
	

func _on_switch_pressed() -> void:
	if not App.game_status.lights_on: 
		App.ui.open_scene_in_focus(preload("res://Rooms/Room1/LightSwitchFocus.tscn").instantiate())
		

func _on_area_2d_mouse_entered() -> void:
	if not App.game_status.lights_on: App.mouse.hover_on($Switch)

func _on_area_2d_mouse_exited() -> void:
	if not App.game_status.lights_on: App.mouse.hover_out()

var dropped = false
func _on_pipe_game_pipes_connected() -> void:
	if not dropped:
		dropped = true
		var item = preload("res://Items/sync_module.tscn").instantiate()
		item.position = Vector2(464,520)
		add_child(item)
		item._on_released()
