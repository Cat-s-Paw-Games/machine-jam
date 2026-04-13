extends Area2D
class_name DropArea

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D):
	var parent = area.get_parent()
	if parent is DraggableItem:
		parent.dropped.connect(_on_item_dropped)

func _on_area_exited(area: Area2D):
	var parent = area.get_parent()
	if parent is DraggableItem:
		parent.dropped.disconnect(_on_item_dropped)
		_on_item_exited(parent)

func _on_item_dropped(item : DraggableItem):
	pass

func _on_item_exited(item: DraggableItem):
	pass
