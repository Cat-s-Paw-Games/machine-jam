extends Node2D

@export var fireplace : Node

var hover = false

func _ready() -> void:
	App.events.activate_generator.connect(_on_activate_generator)

func _process(delta: float) -> void:
	if App.game_status.water_linked && App.game_status.fire_lit:
		if not App.game_status.generator_active: 
			App.events.activate_generator.emit()
		if App.game_status.steam < App.game_status.max_steam:
			App.game_status.steam = App.game_status.steam+delta*5

func check_state():
	var checks_failed = []
	if not App.game_status.fire_lit: checks_failed.append("to be hotter")
	if not App.game_status.water_linked: checks_failed.append("to get a water supply")
	if checks_failed.size() > 0:
		var text = "This generator needs %s" % " and ".join(PackedStringArray(checks_failed))
		App.show_popup(text, {"close_on_click": true})

func _on_activate_generator():
	$SteamEmitter.emitting = true
	$AudioStreamPlayer2D.play("res://assets/music/sfx/generator_loop.mp3")

func _on_touch_screen_button_pressed() -> void:
	check_state()
