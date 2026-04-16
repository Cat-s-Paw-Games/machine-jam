extends Node
class_name GameManager

var inventory : Inventory

const ITEMS_DIR : String = "res://globals/items/"

#var amenities : Dictionary = {}
var items : Dictionary = {}

func _ready() -> void:
	populate_items()
	
	
func setup() -> void:
	populate_items()

func start_game_setup():
	inventory = get_tree().root.get_node("Main/UI/Inventory")

func populate_items():
	for item_res in ResourceLoader.list_directory(ITEMS_DIR):
		var item = ResourceLoader.load(ITEMS_DIR + item_res)
		items[item.id] = item

func set_game_var(var_name, value):
	set(var_name, value)
