extends TouchScreenButton
class_name DraggableItem

signal dropped(item : DraggableItem)

var dragging = false
var drag_offset = Vector2()

func _ready():
	pressed.connect(_on_pressed)
	released.connect(_on_released)

func use():
	pass

func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() + drag_offset
	_process_item(_delta)

func _process_item(_delta: float):
	pass

func _on_pressed():
	dragging = true
	drag_offset = global_position - get_global_mouse_position()

func _on_released():
	dragging = false
	drag_offset = Vector2()
	dropped.emit(self)
