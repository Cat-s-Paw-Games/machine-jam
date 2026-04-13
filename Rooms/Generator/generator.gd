extends DropArea

signal water_filled

var has_water = false

func _on_item_dropped(item : DraggableItem):
	if item is Bucket && item.is_full:
		has_water = true
		water_filled.emit()
		item.change_to_empty_bucket()
