extends TouchScreenButton

var enabled = false

func _on_pressed() -> void:
	if !enabled:
		enabled = true
		await shake()
		App.audio.play("main","res://assets/music/sfx/lights_on.mp3",{"volume_db":7.5})
		App.audio.play("sfx","res://assets/music/sfx/close_door.mp3")
		texture_normal = preload("res://assets/images/switch_on.png")
		await get_tree().create_timer(1.8).timeout
		App.ui.close_scene_in_focus()
		App.events.switch_lights_on.emit()
	

func shake():
	var tween = create_tween()
	var start_pos = position
	var shake_amount = 3

	for i in range(4):
		tween.tween_property(self, "position", start_pos + Vector2(shake_amount, 0), 0.05)
		tween.tween_property(self, "position", start_pos + Vector2(-shake_amount, 0), 0.05)
	tween.tween_property(self, "position", start_pos, 0.05)
	await tween.finished
