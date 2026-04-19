extends PanelContainer
class_name ConsoleMachine

var current_item = null
func _ready():
	%InventorySlot.added_item_to_slot.connect(_on_item_add)
	%InventorySlot.removed_item_from_slot.connect(_on_item_remove)

func _on_item_add(item_id : String):
	current_item = item_id
	if item_id == "bound_relic":
		%Console.correct_item = true
	else:
		%Console.correct_item = false
	
func _on_item_remove(index : int):
	current_item = null
	%Console.correct_item = false

func _on_close_pressed() -> void:
	if current_item: App.ui.inventory.add_item(current_item)
	App.ui.close_console()
