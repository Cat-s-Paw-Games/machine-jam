extends DraggableItem
class_name WoodLogs

var placed = false

func drag_item():
	if !placed:
		super()

func use_after():
	print(item.id)
	if item.id == "wood_logs_fire":
		App.game_status.fire_lit = true
