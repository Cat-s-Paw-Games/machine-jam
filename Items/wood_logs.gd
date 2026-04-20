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
