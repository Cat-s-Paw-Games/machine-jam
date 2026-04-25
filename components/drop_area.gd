extends Area2D
class_name DropArea

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_area_entered(area: Area2D):
	print(area.get_parent())
	var parent = area.get_parent()
	if parent is DraggableItem:
		parent.dropped.connect(_on_item_dropped)

func _on_area_exited(area: Area2D):
	var parent = area.get_parent()
	if parent is DraggableItem:
		parent.dropped.disconnect(_on_item_dropped)
		_on_item_exited(parent)

func _on_item_dropped(_item : DraggableItem):
	pass

func _on_item_exited(_item: DraggableItem):
	pass


func _on_mouse_entered() -> void:
	if App.mouse.hover_type != MouseService.HOVER_TYPE.INVENTORY_DROP:
		App.mouse.hover_on(self, MouseService.HOVER_TYPE.INSPECTABLE)

func _on_mouse_exited() -> void:
	if App.mouse.hover_type != MouseService.HOVER_TYPE.INVENTORY_DROP:
		App.mouse.hover_out()
