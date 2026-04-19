extends DraggableItem
class_name PickableItem

func _on_pressed() -> void:
	if not App.game_status.lights_on: return
	if App.ui.inventory.add_item(item.id):
		queue_free()
		App.mouse.hover_out()
