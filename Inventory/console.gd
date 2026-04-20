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
	elif item_id.contains("floppy_"):
		%Console.floppy_log = true
		%Console.current_floppy = App.items[item_id]
		check_floppy_line()
	else:
		%Console.floppy_log = false
		%Console.current_floppy = null
		check_floppy_line()
		%Console.correct_item = false

func check_floppy_line():
	var floppy_menu_line = "> Copy Floppy Log"
	if %Console.floppy_log:
		if !%Console.screens["main_menu"]["lines"].has(floppy_menu_line):
			%Console.screens["main_menu"]["lines"].append(floppy_menu_line)
	else:
		if %Console.screens["main_menu"]["lines"].has(floppy_menu_line):
			%Console.screens["main_menu"]["lines"].erase(floppy_menu_line)
	%Console.render()

func _on_item_remove(index : int):
	current_item = null
	%Console.correct_item = false
	%Console.floppy_log = false

func _on_close_pressed() -> void:
	if current_item: App.ui.inventory.add_item(current_item)
	App.ui.close_console()
