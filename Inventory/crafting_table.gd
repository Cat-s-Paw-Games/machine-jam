extends PanelContainer

@onready var crafting_grid: GridContainer = %CraftingGrid
@onready var output_slot: InventorySlot = %OutputSlot

func _ready():
	crafting_grid.get_child(0).fill_slot("bucket_empty")
	crafting_grid.get_child(1).fill_slot("bucket_empty")
	crafting_grid.get_child(2).fill_slot("bucket_empty")
	crafting_grid.get_child(3).fill_slot("bucket_empty")
	output_slot.fill_slot("bucket_water")

func clear_grid():
	for child in crafting_grid.get_children():
		child.empty_slot()

func craft_item():
	clear_grid()

func _on_output_slot_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
			craft_item()
