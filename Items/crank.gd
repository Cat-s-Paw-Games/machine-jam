extends DraggableItem

var placed = false

func drag_item():
	if !placed:
		super()

func transform_next():
	if item.transforms_into != "":
		item = item.transform()
		set_item()
