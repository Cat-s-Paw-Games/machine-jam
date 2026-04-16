extends DropArea

var logs : WoodLogs = null

func _on_item_dropped(item : DraggableItem):
	if item is WoodLogs:
		logs = item
		logs.placed = true
		logs.global_position = global_position - (item.texture_normal.get_size() * item.scale) / 2
		logs.fire_lit.connect(_on_fire_lit)
		logs.check_fire()

func _on_fire_lit():
	App.game_status.fire_lit = true
