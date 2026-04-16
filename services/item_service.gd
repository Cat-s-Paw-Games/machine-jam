extends Node
class_name ItemService


const ITEMS_DIR : String = "res://globals/items/"

var items : Dictionary = {}

func setup() -> void:
	for item_res in ResourceLoader.list_directory(ITEMS_DIR):
		var item = ResourceLoader.load(ITEMS_DIR + item_res)
		items[item.id] = item
