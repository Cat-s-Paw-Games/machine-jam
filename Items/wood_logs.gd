extends DraggableItem
class_name WoodLogs

var placed = false

func drag_item():
	if !placed:
		super()

func change_to_logs_hot():
	item = item.transform()
	set_item()

func change_to_logs_fire():
	item = item.transform()
	set_item()
