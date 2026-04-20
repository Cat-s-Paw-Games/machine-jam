extends CanvasLayer

@onready var menu_btn: Button = $MenuBtn

func _ready() -> void:
	App.events.item_added.connect(func(_id): 
		App.mouse.hover_out()
		App.ui.inventory_visible = true
		%InventoryButton.visible = true
	)

func _on_inventory_button_pressed() -> void:
	App.ui.toggle_inventory()


func _on_menu_btn_pressed() -> void:
	get_tree().paused = true
	$Menu.show()
