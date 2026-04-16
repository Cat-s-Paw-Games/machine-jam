extends DraggableItem


func _on_pressed() -> void:
	if GameManager.inventory.add_item(item.id):
		queue_free()
