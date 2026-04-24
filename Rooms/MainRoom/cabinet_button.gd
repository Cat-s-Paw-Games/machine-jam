extends TouchScreenButton

var open = false

func _ready() -> void:
	
	var hitbox = find_child("Area2D") 
	
	if hitbox:
		hitbox.mouse_entered.connect(_on_mouse_entered)
		hitbox.mouse_exited.connect(_on_mouse_exited)
	App.events.cabinet_open.connect(func():
		if App.game_status.tesseract_found:
			queue_free()
		scale = Vector2(2,3)
		position.y -= 20
		App.game_status.combination = [5,2,6]
		open = true
		App.ui.close_scene_in_focus()
	)

func _on_mouse_entered():
	App.mouse.hover_on(self)
func _on_mouse_exited():
	App.mouse.hover_out()
	
func hover_text():
	if not open: return "A small cabinet with a lock."
	return "It seems there's another lock inside"

func _on_pressed() -> void:
	if App.in_focus: return
	App.ui.open_scene_in_focus(preload("res://Rooms/MainRoom/CabinetCode.tscn").instantiate())
