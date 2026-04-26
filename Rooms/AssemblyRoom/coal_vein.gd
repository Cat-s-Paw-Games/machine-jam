extends DropArea

var amount = 2

func use_inventory_item(item_id : String) -> bool:
	if item_id == "pickaxe" && amount > 0:
		App.audio.play("sfx","res://assets/music/sfx/mining_coal.wav")
		App.ui.inventory.add_item("coal")
		amount -= 1
		App.mouse.hover_out()
		if amount <= 0:
			disable_collisions()
		return true
	return false

func disable_collisions():
	monitorable = false
	monitoring = false
	input_pickable = false
	mouse_entered.disconnect(_on_mouse_entered)
	mouse_exited.disconnect(_on_mouse_exited)

func hover_text():
	return "A coal vein"

func _on_mouse_entered() -> void:
	App.mouse.hover_on(self, App.mouse.HOVER_TYPE.INSPECTABLE)

func _on_mouse_exited() -> void:
	App.mouse.hover_out()
