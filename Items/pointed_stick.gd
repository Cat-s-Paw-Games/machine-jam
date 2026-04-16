extends DraggableItem


func _on_pressed() -> void:
	if App.gamemanager.inventory.add_item(item.id):
		queue_free()
