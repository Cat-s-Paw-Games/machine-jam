extends Node2D
class_name GameCursor

@onready var sprite: Sprite2D = $Sprite2D

var text: String: 
	get():
		return tooltip.text
	set(text):
		tooltip.text = text
		
var tooltip: Label

func _ready() -> void:
	tooltip = Label.new()
	add_child(tooltip)
	tooltip.add_theme_font_size_override("font_size",30)
	tooltip.position.x += 10
	tooltip.position.y -= 30

func set_texture(tex: Texture2D) -> void:
	sprite.texture = tex

func set_hotspot(offset: Vector2) -> void:
	sprite.position = -offset
