extends Node
class_name UIService

var ui_instance

var inventory_visible = false
var inventory_open = false
var inventory : InventoryWheel

var console : PanelContainer = null
var crafting : Control = null

func setup()->void:
	var ui = preload("res://ui/ui.tscn")
	ui_instance = ui.instantiate()
	get_tree().root.add_child.call_deferred(ui_instance)
	inventory = ui_instance.get_node("InventoryWheel/InventoryWheel")
	
func add_ui_child(node: Node):
	ui_instance.add_child(node)

func open_crafting():
	disable_touch_btns()
	App.navigation_enabled = false
	App.in_focus = true
	crafting = preload("res://Inventory/crafting_table.tscn").instantiate()
	ui_instance.add_child(crafting)
	ui_instance.move_child(crafting,0)
	UIAnimation.animate_pop(crafting)
	crafting.smoke_particles.emitting = true

func enable_touch_btns():
	for btn in get_tree().get_nodes_in_group("touch_buttons"):
		btn.process_mode = Node.PROCESS_MODE_ALWAYS
		
func disable_touch_btns():
	for btn in get_tree().get_nodes_in_group("touch_buttons"):
		btn.process_mode = Node.PROCESS_MODE_DISABLED

func close_crafting():
	if crafting:
		enable_touch_btns()
		App.navigation_enabled = true
		App.in_focus = false
		await UIAnimation.animate_shrink(crafting)
		crafting.queue_free()
		crafting = null
		
func toggle_inventory():
	if inventory_open:
		await inventory.close()
	else:
		await inventory.open()
	inventory_open = !inventory_open

func open_console():
	enable_touch_btns()
	App.navigation_enabled = false
	App.in_focus = true
	console = preload("res://Inventory/console.tscn").instantiate()
	ui_instance.add_child(console)
	ui_instance.move_child(console,0)
	UIAnimation.animate_pop(console)

func close_console():
	if console:
		disable_touch_btns()
		App.in_focus = false
		App.navigation_enabled = true
		await UIAnimation.animate_shrink(console)
		console.queue_free()
		console = null

func close_every_ui():
	inventory_visible = false
	inventory.clear()
	ui_instance.inventory_button.visible = false
	if inventory_open:
		toggle_inventory()
	close_crafting()
	close_console()

func open_scene_in_focus(scene: Node):
	var focus = get_tree().root.get_node("UI/Focus")
	for c in focus.get_children():
		c.queue_free()
	App.in_focus = true
	App.navigation_enabled = false
	focus.add_child(scene)

func close_scene_in_focus():
	App.in_focus = false
	App.navigation_enabled = true
	var focus = get_tree().root.get_node("UI/Focus")
	for c in focus.get_children():
		c.queue_free()

func _input(_event: InputEvent) -> void:
	if inventory_visible && Input.is_action_just_pressed("inventory_toggle"):
		toggle_inventory()
	
	if Input.is_action_just_pressed("close_ui"):
		if App.in_focus:
			close_scene_in_focus()
		if crafting:
			crafting._on_close_pressed()
		if console:
			console._on_close_pressed()

func insert_item(item_id : String) -> bool:
	if console:
		if console.inventory_slot.is_empty:
			console.inventory_slot.fill_slot(item_id)
			return true
	
	if crafting:
		for panel in crafting.crafting_grid.get_children():
			var slot = panel.get_child(0)
			if slot.is_empty:
				slot.fill_slot(item_id)
				return true
	
	return false
