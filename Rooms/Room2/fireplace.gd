extends DropArea

var logs : WoodLogs = null

func _on_item_dropped(item : DraggableItem):
	if item is WoodLogs:
		logs = item
		item.placed = true
		item.global_position = global_position - (item.texture_normal.get_size() * item.scale) / 2
