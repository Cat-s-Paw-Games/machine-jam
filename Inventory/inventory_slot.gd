extends TextureRect

signal item_data_dropped(at_position : Vector2)

@export var item : Item = null


func empty_slot():
	item = null
	texture = null

func fill_slot(item_id : String):
	item = GameManager.items[item_id]
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
	set_drag_preview(preview)
	
	drag_data = {
		"item": item,
		"source": get_parent().get_child(get_index()) # the slot
	}
	return drag_data


func _can_drop_data(_at_position, data):
	return data.has("item") && data["item"] != null

func _drop_data(_at_position, data):
	var source_slot = data["source"]
	
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
	
	item = source_item
	source_slot.item = temp

	update_visual()
	source_slot.update_visual()

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
	if _drag_data == {}: return
	var camera = get_tree().root.get_node("Main/GameView/Camera2D")
	var space : PhysicsDirectSpaceState2D = camera.get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = camera.get_global_mouse_position()
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var result = space.intersect_point(query)
	
	# THIS DOESN'T WORK BECAUSE CAMERA DOESN'T MOVE
	
	print(camera.get_global_mouse_position())
	print(result)
	#query.collide_with_areas = true
	#query.collision_mask = 0xFFFFFFFF
	#query.position = camera.get_global_mouse_position()
	#
	#var result = space.intersect_point(query)
	#
	#if result.size() > 0:
		#print("collided: ", result[0].collider)
		##result[0].collider.use_item(data)
