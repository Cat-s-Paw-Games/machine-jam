extends DraggableItem
class_name PickableItem

func _on_pressed() -> void:
	if not App.game_status.lights_on: return
	if App.ui.inventory.add_item(item.id):
		App.mouse.hover_out()
		queue_free()
