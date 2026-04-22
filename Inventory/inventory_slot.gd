extends TextureRect
class_name InventorySlot

signal added_item_to_slot(item_id:String)
signal removed_item_from_slot()
@export var item : Item = null

var hover_timer: float = 0.0
var is_dragging_over: bool = false
var hover_timeout: float = 1.0

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(delta):
	# Controlla se stiamo draggando e il mouse è su questo slot
	if get_tree().root.gui_is_dragging():
		if get_global_rect().has_point(get_global_mouse_position()):
			hover_timer += delta
			if hover_timer >= hover_timeout:
				_trigger_wheel_rotate()
				hover_timer = 0.0
		else:
			# Il mouse non è più su questo slot
			hover_timer = 0.0
	else:
		# Non stiamo più draggando
		hover_timer = 0.0
		is_dragging_over = false

func _on_mouse_entered():
	App.mouse.hover_on(self)
	if get_tree().root.gui_is_dragging():
		is_dragging_over = true
		hover_timer = 0.0
	
func _on_mouse_exited():
	App.mouse.hover_out()
	is_dragging_over = false
	hover_timer = 0.0

func _trigger_wheel_rotate():
	# Trova la wheel parent
	var wheel = get_parent()
	if not wheel or not wheel.has_method("rotate_wheel"):
		return
	
	# Ottieni l'indice dello slot corrente e quello attivo della wheel
	var current_slot_index = get_index()
	var active_slot_index = wheel.active_slot
	
	# Determina la direzione: +1 se successivo, -1 se precedente
	var direction = 0
	if current_slot_index > active_slot_index:
		direction = 1
	elif current_slot_index < active_slot_index:
		direction = -1
	
	if direction != 0:
		wheel.rotate_wheel(direction)

func empty_slot():
	removed_item_from_slot.emit()
	item = null
	texture = null
	
	# Riordina la wheel: sposta questo slot in fondo
	var wheel = get_parent()
	if wheel and wheel.has_method("rotate_wheel"):
		var current_index = get_index()
		
		# Se lo slot corrente è quello selezionato, seleziona il prossimo
		if current_index == wheel.active_slot:
			wheel.rotate_wheel(1)
		
		# Sposta lo slot vuoto in fondo (come ultimo child)
		wheel.move_child(self, -1)
		
		# Ricalcola le posizioni di tutti gli slot sulla wheel
		if wheel.has_method("recalculate_slot_positions"):
			wheel.recalculate_slot_positions()

func fill_slot(item_id : String):
	item = App.items[item_id]
	added_item_to_slot.emit(item_id)
	update_visual()

func update_visual():
	if item:
		texture = item.texture
		if item.shiny:
			material = preload("res://assets/shaders/shiny_shader.tres")
	else:
		texture = null

var drag_data = {}
func _get_drag_data(_at_position):
	App.mouse.set_preview(self)
	App.mouse.hover_type = MouseService.HOVER_TYPE.INVENTORY_DROP
	
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
	App.mouse.hover_type = MouseService.HOVER_TYPE.NORMAL
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
		App.mouse.unset_preview()
		if not is_drag_successful():
			await try_drop_into_world(drag_data)
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
	elif dropped_on && dropped_on.has_method("use_inventory_item"):
		if dropped_on.use_inventory_item(_drag_data["item"].id):
			_drag_data["source"].empty_slot()
	App.mouse.hover_type = MouseService.HOVER_TYPE.NORMAL

func hover_text():
	if item:
		return item.name
	return ""
