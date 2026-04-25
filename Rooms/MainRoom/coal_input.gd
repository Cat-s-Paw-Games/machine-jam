extends DropArea

func use_inventory_item(item_id : String) -> bool:
	if item_id == "coal":
		if App.game_status.max_steam < 80:
			App.game_status.max_steam = 80
		return true
		queue_free()
	return false

func hover_text():
	return "Coal Input"

func _on_mouse_entered() -> void:
	App.mouse.hover_on(self,App.mouse.HOVER_TYPE.INSPECTABLE)

func _on_mouse_exited() -> void:
	App.mouse.hover_out()
