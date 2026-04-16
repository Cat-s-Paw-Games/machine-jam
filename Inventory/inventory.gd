extends HBoxContainer
class_name Inventory

const INVENTORY_SLOT = preload("uid://bm847rff3ls1r")

@export var slots_number : int = 7

func _ready() -> void:
	for i in range(slots_number):
		var slot = INVENTORY_SLOT.instantiate()
		add_child(slot)

func clear_inventory():
	for child in get_children():
		child.empty_slot()

func get_next_free_slot_id() -> int:
	for child in get_children():
		if child.item == null:
			return child.get_index()
	return -1

func add_item(item_id : String):
	var slot_id = get_next_free_slot_id()
	if slot_id > -1:
		get_child(slot_id).fill_slot(item_id)
		return true
	return false

func remove_item(slot_id : int):
	get_child(slot_id).empty_slot()
