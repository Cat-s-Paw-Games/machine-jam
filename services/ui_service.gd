extends Node
class_name UIService

var ui_instance

var inventory_visible = false
var inventory_open = false
var inventory : Inventory

var console : PanelContainer = null
var crafting : PanelContainer = null

func setup()->void:
	var ui = preload("res://ui/ui.tscn")
	ui_instance = ui.instantiate()
	get_tree().root.add_child.call_deferred(ui_instance)
	inventory = ui_instance.get_node("Inventory/MarginContainer/ItemSlotContainer")
	
func add_ui_child(node: Node):
	ui_instance.add_child(node)

func open_crafting():
	App.navigation_enabled = false
	App.in_focus = true
	crafting = preload("res://Inventory/crafting_table.tscn").instantiate()
	ui_instance.add_child(crafting)
	UIAnimation.animate_pop(crafting)

func close_crafting():
	if crafting:
		App.navigation_enabled = true
		App.in_focus = false
		await UIAnimation.animate_shrink(crafting)
		crafting.queue_free()
		crafting = null
		
func toggle_inventory():
	if inventory_open:
		inventory_open = false
		UIAnimation.animate_slide_to_top(get_tree().root.get_node("UI/Inventory"))
	else:
		inventory_open = true
		UIAnimation.animate_slide_from_top(get_tree().root.get_node("UI/Inventory"), -20.0)

func open_console():
	App.navigation_enabled = false
	App.in_focus = true
	console = preload("res://Inventory/console.tscn").instantiate()
	ui_instance.add_child(console)
	UIAnimation.animate_pop(console)

func close_console():
	if console:
		App.in_focus = false
		App.navigation_enabled = true
		await UIAnimation.animate_shrink(console)
		console.queue_free()
		console = null

func close_every_ui():
	if inventory_open:
		toggle_inventory()
	close_crafting()
	close_console()

func open_scene_in_focus(scene: Node):
	var focus = get_tree().root.get_node("UI/Focus")
	for c in focus.get_children():
		c.queue_free()
	App.in_focus = true
	focus.add_child(scene)

func close_scene_in_focus():
	App.in_focus = false
	var focus = get_tree().root.get_node("UI/Focus")
	for c in focus.get_children():
		c.queue_free()

func _input(_event: InputEvent) -> void:
	if inventory_visible && Input.is_action_just_pressed("inventory_toggle"):
		toggle_inventory()
