extends Node2D
class_name GameCursor

@onready var sprite: Sprite2D = $Sprite2D

func set_texture(tex: Texture2D) -> void:
	sprite.texture = tex

func set_hotspot(offset: Vector2) -> void:
	sprite.position = -offset
