extends Node
class_name ItemService


const ITEMS_DIR : String = "res://globals/items/"
const FLOPPY_DIR : String = "res://globals/items/floppy_logs/"

var items : Dictionary = {}

func setup() -> void:
	for item_res in ResourceLoader.list_directory(ITEMS_DIR):
		if item_res.contains("floppy"):
			continue
		var item = ResourceLoader.load(ITEMS_DIR + item_res)
		items[item.id] = item
	
	# floppies
	for item_res in ResourceLoader.list_directory(FLOPPY_DIR):
		var item = ResourceLoader.load(FLOPPY_DIR + item_res)
		items[item.id] = item
