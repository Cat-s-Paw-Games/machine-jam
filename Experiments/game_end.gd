extends PanelContainer



func _on_button_pressed() -> void:
	get_tree().paused = false
	App.game_status.reset()
	queue_free()
	get_tree().reload_current_scene()
