extends CanvasLayer

var inventory_open = false

func _ready() -> void:
	App.events.item_added.connect(func(_id): 
		App.mouse.hover_out()
		%InventoryButton.visible = true
	)

func _on_inventory_button_pressed() -> void:
	if inventory_open: 
		inventory_open = false
		App.navigation_enabled = true
		UIAnimation.animate_slide_to_top($Inventory)
	else: 
		inventory_open = true
		App.navigation_enabled = false
		UIAnimation.animate_slide_from_top($Inventory)
