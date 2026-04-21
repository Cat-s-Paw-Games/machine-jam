extends Panel

var active_slot = 1
var item_count = 12
var step = TAU / item_count  # TAU = 2π

@onready var item_slots = get_children()

func _ready():
	add_item("aether_chamber")
	add_item("bound_relic")
	add_item("floppy_card_game")
	add_item("aether_chamber")
	add_item("bound_relic")
	add_item("floppy_card_game")
	add_item("aether_chamber")
	add_item("bound_relic")
	add_item("floppy_card_game")
	add_item("aether_chamber")
	add_item("bound_relic")
	add_item("floppy_card_game")

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
	rotation = round(rotation / step) * step  # snap first
	rotation += direction * step              # move exactly 1 slot
	
	for slot in item_slots:
		slot.pivot_offset = slot.size / 2
		slot.rotation = -rotation
		slot.scale = Vector2(1,1)
	
	active_slot += direction
	if active_slot < 0:
		active_slot = get_child_count() - 1
	elif active_slot >= get_child_count():
		active_slot = 0
	
	var slot = get_child(active_slot)
	slot.scale = Vector2(1.5,1.5)
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_left"):
		rotate_wheel(-1)
	if Input.is_action_just_pressed("ui_right"):
		rotate_wheel(1)
