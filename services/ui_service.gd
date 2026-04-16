extends Node
class_name UIService

var inventory : Inventory:
	get():
		return  get_tree().root.get_node("UI/Inventory")

func setup()->void:
	var ui = preload("res://ui/ui.tscn")
	var ui_instance = ui.instantiate()
	get_tree().root.add_child.call_deferred(ui_instance)
	
func add_ui_child(node: Node):
	get_tree().root.get_node("UI").add_child(node)

var crafting_popup:PanelContainer = null
func open_crafting():
	crafting_popup = PanelContainer.new()
	var crafting = preload("res://Inventory/crafting_table.tscn").instantiate()
	crafting_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	crafting_popup.anchor_top = 0.05
	crafting_popup.anchor_bottom = 0.95
	crafting_popup.anchor_left = 0.05
	crafting_popup.anchor_right = 0.95
	crafting_popup.scale = Vector2(0,0)
	crafting_popup.add_child(crafting)
	App.ui.add_ui_child(crafting_popup)
	UIAnimation.animate_pop(crafting_popup)

func close_crafting():
	if crafting_popup:
		UIAnimation.animate_shrink(crafting_popup)
		crafting_popup.queue_free()
		crafting_popup = null
