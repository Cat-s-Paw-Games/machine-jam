extends Node
class_name MouseService

enum HOVER_TYPE {
	NORMAL,
	DROPPABLE,
	INVENTORY_DROP
}

var current_item: Node = null
var hover_type = HOVER_TYPE.NORMAL

var basic_cursor: Texture2D = preload("res://assets/cursors/curs_default.png")
var hover_cursor: Texture2D = preload("res://assets/cursors/curs_pick.png")
var cursor_center: Vector2 = Vector2(0, 0)

var cursor_instance: GameCursor = null
var cursor_layer: CanvasLayer = null

func setup() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	cursor_layer = CanvasLayer.new()
	cursor_layer.layer = 2000
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
	
	if hover_type == HOVER_TYPE.NORMAL:
		cursor_instance.set_texture(hover_cursor if value else basic_cursor)
		cursor_instance.set_hotspot(cursor_center)

func is_hovered(node: Node) -> bool:
	return node == current_item

func hover_on(item: Node, type: HOVER_TYPE = HOVER_TYPE.NORMAL) -> void:
	current_item = item
	hover_type = type
	if current_item and current_item.has_method("hover_text"):
		cursor_instance.text = current_item.hover_text()
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


func set_preview(item: Node):
	var d = item.duplicate()
	d.modulate.a = 0.7
	d.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cursor_instance.preview_item = d
	
func unset_preview():
	cursor_instance.preview_item = null
	
