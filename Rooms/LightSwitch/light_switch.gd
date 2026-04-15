extends Node2D


func _on_switch_pressed() -> void:
	App.events.switch_lights_on.emit()

func _on_area_2d_mouse_entered() -> void:
	App.mouse.hover_on($Switch)

func _on_area_2d_mouse_exited() -> void:
	App.mouse.hover_out()
