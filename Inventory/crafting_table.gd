extends PanelContainer

@onready var crafting_grid: GridContainer = %CraftingGrid
@onready var output_slot: InventorySlot = %OutputSlot

var RECIPES = {
	"bucket_water": ["bucket_empty","bucket_empty","bucket_empty","bucket_empty"]
}

var current_items = {
	0: null,
	1: null,
	2: null,
	3: null
}

func _ready():
	await get_tree().process_frame
	App.ui.inventory.add_item("bucket_empty")
	App.ui.inventory.add_item("bucket_empty")
	App.ui.inventory.add_item("bucket_empty")
	App.ui.inventory.add_item("bucket_empty")

func clear_grid():
	for child in crafting_grid.get_children():
		child.empty_slot()

func craft_item():
	clear_grid()
	output_slot.empty_slot()
	App.ui.inventory.add_item("bucket_water")

func _on_output_slot_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
			craft_item()

func check_recipe():
	var items = current_items.values()
	items.sort()
	for output in RECIPES:
		var ingredients = RECIPES[output]
		ingredients.sort()
		if ingredients == items:
			output_slot.fill_slot(output)
			break
			

func _on_inventory_slot_1_added_item_to_slot(item_id: String) -> void:
	current_items[0] = item_id
	check_recipe()


func _on_inventory_slot_2_added_item_to_slot(item_id: String) -> void:
	current_items[1] = item_id
	check_recipe()


func _on_inventory_slot_3_added_item_to_slot(item_id: String) -> void:
	current_items[2] = item_id
	check_recipe()


func _on_inventory_slot_4_added_item_to_slot(item_id: String) -> void:
	current_items[3] = item_id
	check_recipe()
