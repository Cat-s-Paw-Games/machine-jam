extends DropArea

signal fire_lit
var logs : WoodLogs = null

var hot_ratio : float = 0.0

func _on_item_dropped(item : DraggableItem):
	print("DROPPED")
	if item is WoodLogs:
		logs = item
		item.placed = true
		item.global_position = global_position - (item.texture_normal.get_size() * item.scale) / 2
	if item.item.id == "pointed_stick" && logs.item.id == "wood_logs":
		if item.item.usable_once:
			item.queue_free()
		logs.change_to_logs_hot()
	if item is Straw && logs.item.id == "wood_logs_hot":
		if item.item.usable_once:
			item.queue_free()
		logs.change_to_logs_fire()
		fire_lit.emit()
