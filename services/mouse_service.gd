extends Node
class_name MouseService

var current_item: Node = null

var basic_cursor: Texture2D = preload("res://assets/cursors/curs_default.png")
var hover_cursor: Texture2D = preload("res://assets/cursors/curs_pick.png")
var cursor_center: Vector2 = Vector2(0, 0)

var cursor_instance: GameCursor = null
var cursor_layer: CanvasLayer = null

func setup() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	cursor_layer = CanvasLayer.new()
	cursor_layer.layer = 1001
	add_child(cursor_layer)

	var scene: PackedScene = preload("res://ui/cursor.tscn")
	cursor_instance = scene.instantiate()
	cursor_layer.add_child(cursor_instance)

	cursor_instance.set_texture(basic_cursor)
	cursor_instance.set_hotspot(cursor_center)

func update_cursor_position() -> void:
	if cursor_instance == null:
		return

	cursor_instance.position = get_viewport().get_mouse_position()

func hover(value: bool) -> void:
	if cursor_instance == null:
		return

	cursor_instance.set_texture(hover_cursor if value else basic_cursor)
	cursor_instance.set_hotspot(cursor_center)

func is_hovered(node: Node) -> bool:
	return node == current_item

func hover_on(item: Node) -> void:
	current_item = item
	if current_item and current_item is DraggableItem:
		var resource_item = current_item.item
		cursor_instance.text = resource_item.name
	hover(true)

func hover_out() -> void:
	current_item = null
	cursor_instance.text =""
	hover(false)

func _notification(what: int) -> void:
	if cursor_instance == null:
		return

	if what == NOTIFICATION_WM_MOUSE_ENTER:
		cursor_instance.visible = true
	elif what == NOTIFICATION_WM_MOUSE_EXIT:
		cursor_instance.visible = false
