extends Control

@onready var crafting_grid: GridContainer = %CraftingGrid
@onready var output_slot: InventorySlot = %OutputSlot
@onready var steam_progress_bar: ProgressBar = %SteamProgressBar
@onready var smoke_particles: CPUParticles2D = %SmokeParticles

var current_recipe = null

var RECIPES = {
	"pickaxe": {
		"ingredients": ["handle","metal_scraps"],
		"steam": 20
	},
	"diamond": {
		"ingredients": ["coal"],
		"steam": 20
	},
	"bound_relic": {
		"ingredients": ["sync_module","oscillation_regulator","aether_chamber","spring"],
		"steam": 40
	},
	"supercharged_relic": {
		"ingredients": ["sync_module","diamond","aether_chamber_charged","tesseract"],
		"steam": 80
	}
}

var current_items = {
	0: null,
	1: null,
	2: null,
	3: null
}

func add_steam_warning():
	#%SteamLabel.add_theme_color_override("font_color",Color.RED)
	%OutputSlotX.visible = true

func remove_steam_warning():
	#%SteamLabel.remove_theme_color_override("font_color")
	%OutputSlotX.visible = false

func _ready():
	for panel in crafting_grid.get_children():
		var slot = panel.get_child(0)
		slot.added_item_to_slot.connect(_on_inventory_slot_added_item_to_slot.bind(panel.get_index()))
		slot.removed_item_from_slot.connect(_on_inventory_slot_removed_item_from_slot.bind(panel.get_index()))
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
			App.game_status.steam -= current_recipe["steam"]
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
			else:
				remove_steam_warning()
			
	if not found:
		current_recipe = null
		output_slot.empty_slot()
		remove_steam_warning()

func _on_inventory_slot_added_item_to_slot(item_id: String, index: int) -> void:
	current_items[index] = item_id
	check_recipe()


func _on_inventory_slot_removed_item_from_slot(index: int) -> void:
	current_items[index] = null
	check_recipe()


func _on_close_pressed() -> void:
	smoke_particles.emitting = false
	for item in current_items.values():
		if item: App.ui.inventory.add_item(item)
	App.ui.close_crafting()

func _on_steam_changed():
	var steam = App.game_status.steam
	steam_progress_bar.value = steam
	check_recipe()
