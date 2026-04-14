extends Node

const ITEMS_DIR : String = "res://globals/items/"

#var amenities : Dictionary = {}
var items : Dictionary = {}

func _ready() -> void:
	populate_items()


func populate_items():
	for item_res in DirAccess.get_files_at(ITEMS_DIR):
		var item = ResourceLoader.load(ITEMS_DIR + item_res)
		items[item.id] = item
