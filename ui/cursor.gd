extends Node2D
class_name GameCursor

@onready var sprite: Sprite2D = $Sprite2D

var text: String: 
	get():
		return tooltip.text
	set(text):
		tooltip.text = text
		
		
var preview_item: Node: 
	get():
		return preview.get_child(0)
	set(item):
		if item == null:
			for c in preview.get_children():
				c.queue_free()
		else:
			preview.add_child(item)
		
var tooltip: Label
var preview: BoxContainer

func _ready() -> void:
	tooltip = Label.new()
	add_child(tooltip)
	tooltip.add_theme_font_size_override("font_size",30)
	tooltip.position.x += 10
	tooltip.position.y -= 30
	
	preview = BoxContainer.new()
	add_child(preview)
	preview.position.x -= 10
	preview.position.y -= 30

func set_texture(tex: Texture2D) -> void:
	sprite.texture = tex

func set_hotspot(offset: Vector2) -> void:
	sprite.position = -offset
