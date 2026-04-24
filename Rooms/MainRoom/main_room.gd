extends Node2D

func _ready():
	$BG.queue_free()

func _on_switch_pressed() -> void:
	if not App.game_status.lights_on: 
		App.ui.open_scene_in_focus(preload("res://Rooms/MainRoom/LightSwitchFocus.tscn").instantiate())
