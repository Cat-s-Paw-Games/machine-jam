extends Node
class_name UIService

var inventory_open = false
var inventory : Inventory:
	get():
		return  get_tree().root.get_node("UI/Inventory/MarginContainer/ItemSlotContainer")

var ui_instance

func setup()->void:
	var ui = preload("res://ui/ui.tscn")
	ui_instance = ui.instantiate()
	get_tree().root.add_child.call_deferred(ui_instance)
	
func add_ui_child(node: Node):
	get_tree().root.get_node("UI").add_child(node)

var crafting_canvas:CanvasLayer = null
func open_crafting():
	App.navigation_enabled = false
	crafting_canvas = CanvasLayer.new()
	var crafting_popup = PanelContainer.new()
	var crafting = preload("res://Inventory/crafting_table.tscn").instantiate()
	crafting_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	crafting_popup.anchor_top = 0.05
	crafting_popup.anchor_bottom = 0.95
	crafting_popup.anchor_left = 0.05
	crafting_popup.anchor_right = 0.95
	crafting_popup.scale = Vector2(0,0)
	crafting_popup.add_child(crafting)
	crafting_canvas.add_child(crafting_popup)
	get_tree().root.add_child(crafting_canvas)
	UIAnimation.animate_pop(crafting_popup)

func close_crafting():
	if crafting_canvas:
		App.navigation_enabled = true
		UIAnimation.animate_shrink(crafting_canvas.get_child(0))
		crafting_canvas.queue_free()
		crafting_canvas = null
		
func toggle_inventory():
	if inventory_open:
		inventory_open = false
		#App.navigation_enabled = true
		UIAnimation.animate_slide_to_top(get_tree().root.get_node("UI/Inventory"))
	else:
		inventory_open = true
		#App.navigation_enabled = false
		UIAnimation.animate_slide_from_top(get_tree().root.get_node("UI/Inventory"))

var console_canvas:CanvasLayer = null
func open_console():
	App.navigation_enabled = false
	console_canvas = CanvasLayer.new()
	var console_popup = PanelContainer.new()
	var console = preload("res://Inventory/console.tscn").instantiate()
	console_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	console_popup.anchor_top = 0.05
	console_popup.anchor_bottom = 0.95
	console_popup.anchor_left = 0.05
	console_popup.anchor_right = 0.95
	console_popup.scale = Vector2(0,0)
	console_popup.add_child(console)
	console_canvas.add_child(console_popup)
	get_tree().root.add_child(console_canvas)
	UIAnimation.animate_pop(console_popup)

func close_console():
	if console_canvas:
		App.navigation_enabled = true
		UIAnimation.animate_shrink(console_canvas.get_child(0))
		console_canvas.queue_free()
		console_canvas = null

func close_every_ui():
	if inventory_open:
		toggle_inventory()
	close_crafting()
	close_console()


func open_scene_in_focus(scene: Node):
	var focus = get_tree().root.get_node("UI/Focus")
	for c in focus.get_children():
		c.queue_free()
	focus.add_child(scene)
	
	
func close_scene_in_focus():
	var focus = get_tree().root.get_node("UI/Focus")
	for c in focus.get_children():
		c.queue_free()
