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
