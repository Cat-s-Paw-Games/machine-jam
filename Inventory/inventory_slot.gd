extends TextureRect
class_name InventorySlot

signal added_item_to_slot(item_id:String)
signal removed_item_from_slot()
@export var item : Item = null


func empty_slot():
	removed_item_from_slot.emit()
	item = null
	texture = null

func fill_slot(item_id : String):
	item = App.items[item_id]
	added_item_to_slot.emit(item_id)
	print("emitting", item_id)
	update_visual()

func update_visual():
	if item:
		texture = item.texture
	else:
		texture = null

var drag_data = {}
func _get_drag_data(_at_position):
	var preview = duplicate()
	preview.modulate.a = 0.7
	App.mouse.set_preview(preview)
	
	drag_data = {
		"item": item,
		"source": get_parent().get_child(get_index()) # the slot
	}
	return drag_data


func _can_drop_data(_at_position, data):
	return data.has("item") && data["item"] != null

func _drop_data(_at_position, data):
	var source_slot = data["source"]
	App.mouse.unset_preview()
	
	if source_slot == self:
		return
	
	swap_items(source_slot)

func swap_items(source_slot):
	var source_item = source_slot.item
	var temp = item
	
	if item:
		if item.material != "" && item.material == source_item.id:
			combine_items(source_slot)
			return
		if source_item && source_item.material != "":
			if item.id == source_item.material:
				combine_items_inverse(source_slot)
				return
	fill_slot(source_item.id)
	if temp == null:
		source_slot.empty_slot()
	else:
		source_slot.fill_slot(temp.id)

func combine_items(source_slot):
	source_slot.empty_slot()
	item = item.transform()
	update_visual()
	
func combine_items_inverse(source_slot):
	item = source_slot.item.transform()
	update_visual()
	source_slot.empty_slot()


func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		if not is_drag_successful():
			try_drop_into_world(drag_data)
			drag_data = {}

func try_drop_into_world(_drag_data):
	if _drag_data == {} || _drag_data["item"] == null:
		return
	
	var dropped_on = App.mouse.current_item
	if dropped_on && dropped_on.has_method("use"):
		if dropped_on.item.material != _drag_data["item"].id:
			return
		dropped_on.use(_drag_data["item"].id)
		_drag_data["source"].empty_slot()
