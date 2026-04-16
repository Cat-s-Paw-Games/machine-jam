extends DraggableItem



func _on_pressed() -> void:
	if App.ui.inventory.add_item(item.id):
		queue_free()
