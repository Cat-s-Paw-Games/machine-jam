extends Node


func _ready() -> void:
	await get_tree().process_frame
	open_door()
	App.audio.play_loop("main","assets/music/main_loop.mp3",{"pitch":0.9})

func open_door():
	await get_tree().create_timer(0.5).timeout
	await shake()
	var open_1 = create_tween().set_parallel(true)
	var left_open_position = - 1920.0 / 2
	var right_open_position = 1920.0 + 1920.0/2
	open_1.tween_property(%DoorLeft, "position:x", left_open_position, 3)
	open_1.tween_property(%DoorRight, "position:x", right_open_position, 3)

	
func shake():
	var tween = create_tween()
	var door_left = %DoorLeft
	var door_right = %DoorRight
	var start_pos_left = door_left.position
	var start_pos_right = door_right.position
	var shake_amount = 2

	for i in range(4):
		tween.tween_property(door_left, "position", start_pos_left + Vector2(shake_amount, 0), 0.05)
		tween.tween_property(door_left, "position", start_pos_left + Vector2(-shake_amount, 0), 0.05)
		
		tween.tween_property(door_right, "position", start_pos_right + Vector2(shake_amount, 0), 0.05)
		tween.tween_property(door_right, "position", start_pos_right + Vector2(-shake_amount, 0), 0.05)
	tween.tween_property(door_left, "position", start_pos_left, 0.05)
	tween.tween_property(door_right, "position", start_pos_right, 0.05)
	await  tween.finished


func _on_new_game_pressed() -> void:
	SceneTransitionManager.change_scene_with_wipe("res://Prologue.tscn")
	


func _on_parallax_prototype_pressed() -> void:
	get_tree().change_scene_to_file("res://Experiments/DanieleExperiments.tscn")


func _on_cucucc_experiments_pressed() -> void:
	SceneTransitionManager.change_scene_with_wipe("res://Experiments/CucuccExperiments.tscn")
