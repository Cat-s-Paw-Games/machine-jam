extends PanelContainer

@onready var crafting_grid: GridContainer = %CraftingGrid
@onready var output_slot: InventorySlot = %OutputSlot

var RECIPES = {
	"bucket_water": {
		"ingredients": ["bucket_empty"]
	},
	"bucket_empty": {
		"ingredients": ["bucket_water"],
		"steam": 10
	}
}

var current_items = {
	0: null,
	1: null,
	2: null,
	3: null
}

#func _process(delta: float) -> void:
#	App.events.steam_increase.emit(delta)

func _ready():
	App.events.steam_changed.connect(func(steam): %SteamLabel.text = str(steam).pad_decimals(2))

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
	var items = current_items.values().filter(func(x):
		return x != null
	)
	items.sort()
	var found = false
	for output in RECIPES:
		var ingredients = RECIPES[output]["ingredients"]
		ingredients.sort()
		if ingredients == items:
			output_slot.fill_slot(output)
			found = true
			
	if not found:
		output_slot.empty_slot()
			

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


func _on_inventory_slot_1_removed_item_from_slot() -> void:
	current_items[0] = null
	check_recipe()


func _on_inventory_slot_2_removed_item_from_slot() -> void:
	current_items[1] = null
	check_recipe()


func _on_inventory_slot_3_removed_item_from_slot() -> void:
	current_items[2] = null
	check_recipe()


func _on_inventory_slot_4_removed_item_from_slot() -> void:
	current_items[3] = null
	check_recipe()
