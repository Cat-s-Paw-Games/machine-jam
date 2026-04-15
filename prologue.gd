extends Node2D

var is_continue = false

func _on_skip_pressed() -> void:
	if is_continue:
		SceneTransitionManager.change_scene_with_wipe("res://main.tscn")
	else:
		%Typewriter.finish()


func _on_typewriter_animation_finished() -> void:
	%ContinueButton.text = "Continue"
	is_continue = true


func _on_continue_button_mouse_entered() -> void:
	App.mouse.hover_on(%ContinueButton)


func _on_continue_button_mouse_exited() -> void:
	App.mouse.hover_out()
