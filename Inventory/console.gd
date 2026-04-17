extends PanelContainer
class_name ConsoleMachine

var current_keys = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null,
	8: null
}

func _ready():
	for panel in %Keys.get_children():
		var slot : InventorySlot = panel.get_child(0)
		slot.added_item_to_slot.connect(_on_item_add.bind(panel.get_index()))
		slot.removed_item_from_slot.connect(_on_item_remove.bind(panel.get_index()))

func _on_item_add(item_id : String, index : int):
	current_keys[index] = item_id
	
func _on_item_remove(index : int):
	current_keys[index] = null

func _on_close_pressed() -> void:
	for item in current_keys.values():
		if item: App.ui.inventory.add_item(item)
	App.ui.close_console()


func _on_confirm_btn_pressed() -> void:
	if current_keys[4] == "bound_relic":
		App.end_game()
