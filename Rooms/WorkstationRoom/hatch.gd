extends Node

@onready var hatch_sprite: Sprite2D = $HatchSprite

func _ready() -> void:
	App.events.hatch_open.connect(_on_hatch_open)

func _on_hatch_open():
	App.audio.play("sfx","res://assets/music/sfx/hatch_open.wav")
	$Button/HoverHint.text = ""
	var tween = create_tween()
	tween.tween_property(hatch_sprite,"position:y", 20, .5)
	tween.tween_property(hatch_sprite,"position:y", -50, .5)

func _on_button_pressed() -> void:
	if App.game_status.end_reached:
		App.events.handle_ending()
