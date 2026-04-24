extends Node

@onready var hatch_sprite: Sprite2D = $HatchSprite

func _ready() -> void:
	App.events.hatch_open.connect(_on_hatch_open)

func _on_hatch_open():
	hatch_sprite.position.y -= 100

func _on_button_pressed() -> void:
	if App.game_status.end_reached:
		App.events.handle_ending()
