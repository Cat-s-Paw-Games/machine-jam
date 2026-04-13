extends TouchScreenButton

var dragging = false
var drag_offset = Vector2()
var dropped = false

func _ready():
	pressed.connect(_on_pressed)
	released.connect(_on_released)

func use():
	queue_free()

func check_dropped():
	if dropped:
		use()

func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() + drag_offset

func _on_pressed():
	dragging = true
	drag_offset = global_position - get_global_mouse_position()

func _on_released():
	dragging = false
	drag_offset = Vector2()
	check_dropped()
