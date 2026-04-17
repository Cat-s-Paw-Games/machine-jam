extends PanelContainer


func _on_resume_btn_pressed() -> void:
	hide()
	get_tree().paused = false


func _on_restart_btn_pressed() -> void:
	hide()
	get_tree().paused = false
	App.game_status.reset()
	get_tree().reload_current_scene()


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_discord_pressed() -> void:
	pass
	#OS.shell_open("https://discord.com/channels/1491350406285234249/1491350406746341481")

func _on_itch_io_pressed() -> void:
	OS.shell_open("https://cats-paw.itch.io/")
