extends PanelContainer
class_name ConsoleMachine

var current_item = null
func _ready():
	%InventorySlot.added_item_to_slot.connect(_on_item_add)
	%InventorySlot.removed_item_from_slot.connect(_on_item_remove)

func _on_item_add(item_id : String):
	current_item = item_id
	if item_id == "bound_relic_charged":
		%Console.correct_item = true
	elif item_id == "floppy_card_game":
		%Console.current_floppy = App.items[item_id]
		add_floppy_line()
	elif item_id.contains("floppy_"):
		%Console.floppy_log = true
		%Console.current_floppy = App.items[item_id]
		add_floppy_line()
	else:
		%Console.floppy_log = false
		%Console.current_floppy = null
		remove_floppy_line()
		%Console.correct_item = false

var floppy_menu_line = "> Copy Floppy Log"
var supercharge_line = "> Install Supercharge protocol"

func add_floppy_line():
	if %Console.current_floppy.id == "floppy_card_game":
		if !%Console.screens["main_menu"]["lines"].has(supercharge_line):
			%Console.screens["main_menu"]["lines"].append(supercharge_line)
	elif %Console.floppy_log:
		if !%Console.screens["main_menu"]["lines"].has(floppy_menu_line):
			%Console.screens["main_menu"]["lines"].append(floppy_menu_line)
	
	%Console.render()

func remove_floppy_line():
	if %Console.screens["main_menu"]["lines"].has(supercharge_line):
		%Console.screens["main_menu"]["lines"].erase(supercharge_line)
	
	if %Console.screens["main_menu"]["lines"].has(floppy_menu_line):
		%Console.screens["main_menu"]["lines"].erase(floppy_menu_line)
	
	%Console.render()


func _on_item_remove():
	current_item = null
	%Console.correct_item = false
	%Console.floppy_log = false
	remove_floppy_line()

func _on_close_pressed() -> void:
	if current_item: App.ui.inventory.add_item(current_item)
	App.ui.close_console()


func _on_console_floppy_saved() -> void:
	if current_item:
		%InventorySlot.empty_slot()
		current_item = null




func _on_console_play_card_game() -> void:
	if %InventorySlot.item && %InventorySlot.item.id == "bound_relic":
		%Console.hide()
		%CardGame.show()

func _on_card_game_won() -> void:
	await get_tree().create_timer(1.0).timeout
	if %InventorySlot.item.id == "bound_relic":
		%InventorySlot.item = %InventorySlot.item.transform()
		%InventorySlot.update_visual()
		%Console.correct_item = true
	%CardGame.hide()
	%Console.show()
