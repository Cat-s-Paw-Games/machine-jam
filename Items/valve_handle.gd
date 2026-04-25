extends DraggableItem
class_name ValveHandle


func _on_mouse_entered():
	if not App.game_status.lights_on: return
	if App.in_focus: return
	App.mouse.hover_on(self, 
		MouseService.HOVER_TYPE.INVENTORY_DROP if App.mouse.hover_type == MouseService.HOVER_TYPE.INVENTORY_DROP
		else MouseService.HOVER_TYPE.DRAGGABLE
	)

func _on_mouse_exited():
	if not App.game_status.lights_on: return
	App.mouse.hover_out()
