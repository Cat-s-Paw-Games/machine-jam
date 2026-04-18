extends  TouchScreenButton

func _on_pressed() -> void:
	if not App.game_status.generator_active:
		App.show_popup("There is no power for this machine",true)
		return
	App.ui.open_console()
