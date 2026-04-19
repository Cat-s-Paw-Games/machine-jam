extends PanelContainer

@onready var crafting_grid: GridContainer = %CraftingGrid
@onready var output_slot: InventorySlot = %OutputSlot

var current_recipe = null

var RECIPES = {
	"bucket_water": {
		"ingredients": ["bucket_empty"]
	},
	"bucket_empty": {
		"ingredients": ["bucket_water"],
		"steam": 10
	},
	"bound_relic": {
		"ingredients": ["sync_module","oscillation_regulator","aether_chamber","spring"],
		"steam": 80
	},
}

var current_items = {
	0: null,
	1: null,
	2: null,
	3: null
}

func add_steam_warning():
	%SteamLabel.add_theme_color_override("font_color",Color.RED)
	%OutputSlotX.visible = true

func remove_steam_warning():
	%SteamLabel.remove_theme_color_override("font_color")
	%OutputSlotX.visible = false

func _ready():
	_on_steam_changed()

func _process(_delta: float) -> void:
	_on_steam_changed()

func clear_grid():
	for child in crafting_grid.get_children():
		child.get_child(0).empty_slot()

func craft_item():
	if current_recipe:
		if current_recipe.has("steam") and current_recipe["steam"] > App.game_status.steam:
			return
		App.ui.inventory.add_item(current_recipe["output"])
		if current_recipe.has("steam"):
			App.events.steam_decrease.emit(current_recipe["steam"])
		clear_grid()
		output_slot.empty_slot()

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
			current_recipe = RECIPES[output]
			current_recipe["output"] = output
			output_slot.fill_slot(output)
			found = true
			if current_recipe.has("steam") and current_recipe["steam"] > App.game_status.steam:
				add_steam_warning()
			
	if not found:
		current_recipe = null
		output_slot.empty_slot()
		remove_steam_warning()
			

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


func _on_close_pressed() -> void:
	for item in current_items.values():
		if item: App.ui.inventory.add_item(item)
	App.ui.close_crafting()

func _on_steam_changed():
	var steam = App.game_status.steam
	%SteamLabel.text = str(steam).pad_decimals(2)
	check_recipe()
