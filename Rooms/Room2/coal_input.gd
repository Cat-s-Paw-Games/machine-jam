extends DropArea

func use_inventory_item(item_id : String):
	if item_id == "coal":
		if App.game_status.max_steam < 80:
			App.game_status.max_steam = 80
		queue_free()

func hover_text():
	return "Coal Input"

func _on_mouse_entered() -> void:
	App.mouse.hover_on(self)

func _on_mouse_exited() -> void:
	App.mouse.hover_out()
