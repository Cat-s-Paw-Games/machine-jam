extends TouchScreenButton
class_name DraggableItem

signal dropped(item : DraggableItem)

var dragging = false
var drag_offset = Vector2()
var hitbox: Area2D

@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Item") var item : Item = Item.new()

func _ready():
	pressed.connect(_on_pressed)
	released.connect(_on_released)
	hitbox = find_child("Area2D") 
	if hitbox:
		hitbox.mouse_entered.connect(func(): App.mouse.hover_on(self))
		hitbox.mouse_exited.connect(func(): App.mouse.hover_out())
	set_item()

func use():
	pass

func set_item():
	texture_normal = item.texture

func _process(_delta: float) -> void:
	drag_item()
	_process_item(_delta)

func _process_item(_delta: float):
	pass

func drag_item():
	if dragging:
		global_position = get_global_mouse_position() + drag_offset

func _on_pressed():
	dragging = true
	drag_offset = global_position - get_global_mouse_position()

func _on_released():
	dragging = false
	drag_offset = Vector2()
	dropped.emit(self)
