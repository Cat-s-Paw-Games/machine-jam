extends Panel
class_name InventoryWheel

var is_rotating = false
var active_slot = 0
var item_count = 12
var step = TAU / item_count  # TAU = 2π
const INVENTORY_SLOT = preload("uid://bm847rff3ls1r")

var current_item_count:
	get():
		var count = 0
		for child in get_children():
			if child.item != null:
				count += 1
		return count

var item_slots:
	get():
		return get_children()

func _ready():
	UIAnimation.animate_shrink(self)
	var radius = (size.x - 152) / 2   # distanza dal centro
	var center = size / 2  # centro della wheel
	var slot_size = 100
	
	
	for i in range(item_count):
		var slot: InventorySlot = INVENTORY_SLOT.instantiate()
		slot.custom_minimum_size = Vector2(slot_size, slot_size)
		slot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		slot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(slot)
		
		# Posiziona lo slot in cerchio attorno al centro, in senso orario
		# Inizia da alto a sinistra (-135°) e prosegue in senso orario
		var start_angle = deg_to_rad(-135)
		var angle = start_angle - (step * i)
		@warning_ignore("integer_division")
		var x = cos(angle) * radius - slot_size/2
		@warning_ignore("integer_division")
		var y = sin(angle) * radius - slot_size/2
		slot.position = center + Vector2(x, y)
	
	highlight_first_slot()


func correct_slots_positions():
	var first_empty_slot = -1
	var last_filled_slot = -1
	var item_numbers = 0
	var i = 0
	var slots = item_slots
	for slot in slots:
		if slot.is_empty:
			if first_empty_slot == -1:
				first_empty_slot = i
		else:
			last_filled_slot = i
			item_numbers += 1
		i += 1
	if first_empty_slot != item_numbers:
		slots[first_empty_slot].swap_items(slots[last_filled_slot])
		

func recalculate_slot_positions():
	var radius = (size.x - 152) / 2
	var center = size / 2
	var slot_size = 100
	var start_angle = deg_to_rad(-135)
	
	for i in range(item_slots.size()):
		var slot = item_slots[i]
		var angle = start_angle - (step * i)
		@warning_ignore("integer_division")
		var x = cos(angle) * radius - slot_size/2
		@warning_ignore("integer_division")
		var y = sin(angle) * radius - slot_size/2
		slot.position = center + Vector2(x, y)

func get_next_free_slot_id() -> int:
	for child in get_children():
		if child.item == null:
			return child.get_index()
	return -1


func add_item(item_id : String):
	var slot_id = get_next_free_slot_id()
	if slot_id > -1:
		App.events.item_added.emit(item_id)
		get_child(slot_id).fill_slot(item_id)
		return true
	return false

func rotate_wheel(direction: int):
	if current_item_count <= 0: return
	is_rotating = true
	correct_slots_positions()
	var tween = create_tween().set_parallel()
	rotation = round(rotation / step) * step  # snap first
	var next_slot = (active_slot + direction + current_item_count) % current_item_count
	var final_rotation = next_slot * step 
	var rotation_loop_time = .5
	var rotation_time = 0.2
	
	if active_slot + direction >= current_item_count || active_slot + direction < 0:
		rotation_time = rotation_loop_time
	
	tween.tween_property(self, "rotation", final_rotation, rotation_time)
	
	for slot in item_slots:
		slot.pivot_offset = slot.size / 2
		tween.tween_property(slot, "rotation", -final_rotation, rotation_time)
		tween.tween_property(slot, "scale", Vector2(1,1), rotation_time)
		slot.z_index = 0
	
	active_slot = next_slot
	
	var slot = get_child(active_slot)
	slot.z_index = 1
	tween.tween_property(slot, "scale", Vector2(2,2), rotation_time)
	await tween.finished
	is_rotating = false

func highlight_first_slot():
	var slot = get_child(active_slot)
	slot.pivot_offset = slot.size / 2
	slot.z_index = 1
	slot.scale = Vector2(2,2)

func _input(_event: InputEvent) -> void:
	if is_rotating:
		return
	
	if App.ui.inventory_open:
		if Input.is_action_just_pressed("ui_up"):
			rotate_wheel(-1)
		if Input.is_action_just_pressed("ui_down"):
			rotate_wheel(1)
		
		if Input.is_action_just_pressed("wheel_up"):
			rotate_wheel(-1)
		if Input.is_action_just_pressed("wheel_down"):
			rotate_wheel(1)

func open():
	await UIAnimation.animate_pop(self)

func close():
	await UIAnimation.animate_shrink(self)
