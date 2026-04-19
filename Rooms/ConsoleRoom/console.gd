extends  TouchScreenButton

func _on_pressed() -> void:
	if App.in_focus: return
	if not App.game_status.generator_active:
		App.show_popup("There is no power for this machine", {"close_on_click": true})
		return
	App.ui.open_console()
