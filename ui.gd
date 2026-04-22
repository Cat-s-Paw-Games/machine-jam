extends CanvasLayer

@onready var menu_btn: Button = $MenuBtn
@onready var inventory_button: TouchScreenButton = %InventoryButton

func _ready() -> void:
	App.events.item_added.connect(func(_id): 
		App.mouse.hover_out()
		App.ui.inventory_visible = true
		inventory_button.visible = true
	)

func _on_inventory_button_pressed() -> void:
	App.ui.toggle_inventory()


func _on_menu_btn_pressed() -> void:
	get_tree().paused = true
	$Menu.show()
