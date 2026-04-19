extends DropArea

func use_inventory_item(item_id : String):
	if item_id == "pickaxe":
		App.ui.inventory.add_item("coal")
		App.mouse.hover_out()
		disable_collisions()

func disable_collisions():
	monitorable = false
	monitoring = false
	input_pickable = false
	mouse_entered.disconnect(_on_mouse_entered)
	mouse_exited.disconnect(_on_mouse_exited)

func hover_text():
	return "Coal Vein"

func _on_mouse_entered() -> void:
	App.mouse.hover_on(self)

func _on_mouse_exited() -> void:
	App.mouse.hover_out()
