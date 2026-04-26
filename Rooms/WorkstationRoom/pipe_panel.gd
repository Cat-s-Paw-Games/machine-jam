extends TouchScreenButton

signal open_panel()
var fallen = false

func _on_pressed() -> void:
	if fallen: return
	App.audio.play("sfx","res://assets/music/sfx/pipe_panel.mp3")
	fallen = true
	open_panel.emit()
	shake_and_rotate(self)
	
func shake_and_rotate(panel: Node2D):
	var hitbox = find_child("Area2D") 
	
	if hitbox:
		App.mouse.hover_out()
		hitbox.queue_free()
	var tween := create_tween()

	var original_pos := panel.position
	var pivot := Vector2(10, 10)

	# --- SHAKE ---
	for i in range(8):
		var offset := Vector2(
			randf_range(-5, 5),
			randf_range(-5, 5)
		)
		tween.tween_property(panel, "position", original_pos + offset, 0.03)

	tween.tween_property(panel, "position", original_pos, 0.04)

	# --- ROTAZIONE ATTORNO AL PIVOT CUSTOM ---
	tween.tween_method(
		func(angle):
			var rad = deg_to_rad(angle)

			# ruota il pivot e poi ricostruisce la posizione
			var rotated_offset = pivot.rotated(rad)
			panel.position = original_pos + pivot - rotated_offset
			panel.rotation = rad,
		0.0,
		135.0,
		0.55
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _ready():
	var hitbox = find_child("Area2D") 
	
	if hitbox:
		hitbox.mouse_entered.connect(_on_mouse_entered)
		hitbox.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	if not App.game_status.lights_on: return
	App.mouse.hover_on(self, App.mouse.HOVER_TYPE.INSPECTABLE)
	
func _on_mouse_exited():
	App.mouse.hover_out()	


func hover_text():
	return "The panel feels loose."
