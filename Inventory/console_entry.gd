extends Label
class_name ConsoleEntry

signal hovered(index : int)
signal selected(index : int)

var hover : bool = false:
	set(new_val):
		hover = new_val
		if is_node_ready():
			text = get_meta("text")
			if hover:
				text = "> " + get_meta("text")

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	add_theme_font_size_override("font_size", 18)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	set_meta("text", text)

func _on_mouse_exited() -> void:
	hover = false


func _on_mouse_entered() -> void:
	hover = true
	hovered.emit(get_index())

func _gui_input(event: InputEvent) -> void:
	if hover:
		if event && event is InputEventMouseButton && event.pressed:
			selected.emit(get_index())
