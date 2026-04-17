extends DropArea
class_name Console

func _unhandled_input(event: InputEvent) -> void:
	if App.mouse.is_hovered(self) && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		click()

func click():
	if not App.game_status.generator_active:
		App.show_popup("There is no power for this machine",true)
		return
	App.ui.open_console()
	
