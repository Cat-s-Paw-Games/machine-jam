extends DropArea

func _ready() -> void:
	super()
#	await get_tree().process_frame
#	App.events.activate_generator.emit()
#	App.ui.inventory.add_item("bucket_water")


func _unhandled_input(event: InputEvent) -> void:
	if App.mouse.is_hovered(self) && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		click()

func click():
	if not App.game_status.generator_active:
		App.show_popup("There is no power for this machine",true)
		return
	
	var popup = PopupPanel.new()
	var crafting = preload("res://Inventory/crafting_table.tscn").instantiate()
	popup.add_child(crafting)
	App.ui.add_ui_child(popup)
	popup.popup_centered()
	
