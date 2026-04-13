extends DraggableItem
class_name WoodLogs

const WOOD_LOGS_HOT = preload("uid://bx8ijlr87iggk")
const WOOD_LOGS_FIRE = preload("uid://8jcndoaiqdd0")

var placed = false

func drag_item():
	if !placed:
		super()

func change_to_logs_hot():
	texture_normal = WOOD_LOGS_HOT

func change_to_logs_fire():
	texture_normal = WOOD_LOGS_FIRE
