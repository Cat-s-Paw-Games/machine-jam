extends DraggableItem
class_name WoodLogs

signal fire_lit
var placed = false

func drag_item():
	if !placed:
		super()

func check_fire():
	if placed and item.id == "wood_logs_fire":
		App.audio.play("sfx", "res://assets/music/sfx/fire_whoosh.mp3")
		$AudioStreamPlayer2D.play()
		fire_lit.emit()

func use_after():
	check_fire()

func hover_text():
	if item.id == "wood_logs_fire": return ""
	if item.id == "wood_logs_hot":
		if App.mouse.dragged_item_id == "paper":
			return "A full sheet won't really take"
		return "I need some tinder"
	if placed: return "I need something to start the fire"
	return super()


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
