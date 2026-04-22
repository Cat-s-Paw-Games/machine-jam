extends PanelContainer
class_name ConsoleMachine

@onready var console = %ConsoleMenu
@onready var inventory_slot: InventorySlot = %InventorySlot

var current_item = null
func _ready():
	inventory_slot.added_item_to_slot.connect(_on_item_add)
	inventory_slot.removed_item_from_slot.connect(_on_item_remove)

func _on_item_add(item_id : String):
	current_item = item_id
	if item_id == "bound_relic_charged":
		console.correct_item = true
	elif item_id == "floppy_card_game":
		console.current_floppy = App.items[item_id]
		add_floppy_line()
	elif item_id.contains("floppy_"):
		console.floppy_log = true
		console.current_floppy = App.items[item_id]
		add_floppy_line()
	else:
		console.floppy_log = false
		console.current_floppy = null
		remove_floppy_line()
		console.correct_item = false

var floppy_menu_line = "Copy Floppy Log"
var supercharge_line = "Install Supercharge protocol"

func add_floppy_line():
	if console.current_floppy.id == "floppy_card_game":
		if !console.screens["main_menu"]["lines"].has(supercharge_line):
			console.screens["main_menu"]["lines"].append(supercharge_line)
	elif console.floppy_log:
		if !console.screens["main_menu"]["lines"].has(floppy_menu_line):
			console.screens["main_menu"]["lines"].append(floppy_menu_line)
	
	console.render()

func remove_floppy_line():
	if console.screens["main_menu"]["lines"].has(supercharge_line):
		console.screens["main_menu"]["lines"].erase(supercharge_line)
	
	if console.screens["main_menu"]["lines"].has(floppy_menu_line):
		console.screens["main_menu"]["lines"].erase(floppy_menu_line)
	
	console.render()


func _on_item_remove():
	current_item = null
	console.correct_item = false
	console.floppy_log = false
	remove_floppy_line()

func _on_close_pressed() -> void:
	if current_item: App.ui.inventory.add_item(current_item)
	App.ui.close_console()


func _on_card_game_won() -> void:
	await get_tree().create_timer(1.0).timeout
	if inventory_slot.item.id == "bound_relic":
		inventory_slot.item = inventory_slot.item.transform()
		inventory_slot.update_visual()
		console.correct_item = true
	%CardGame.hide()
	console.show()


func _on_console_menu_floppy_saved() -> void:
	if current_item:
		inventory_slot.empty_slot()
		current_item = null


func _on_console_menu_play_card_game() -> void:
	if inventory_slot.item && inventory_slot.item.id == "bound_relic":
		console.hide()
		%CardGame.show()
