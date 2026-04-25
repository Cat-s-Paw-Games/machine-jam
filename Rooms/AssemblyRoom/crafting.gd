extends TouchScreenButton

func _on_pressed() -> void:
	if App.in_focus: return
	if not App.game_status.generator_active:
		App.show_popup("There is no power for this machine", {"close_on_click": true})
		return
	App.ui.open_crafting()

func _ready():
	var hitbox = find_child("Area2D") 
	
	if hitbox:
		hitbox.mouse_entered.connect(_on_mouse_entered)
		hitbox.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	App.mouse.hover_on(self)
	
func _on_mouse_exited():
	App.mouse.hover_out()	
