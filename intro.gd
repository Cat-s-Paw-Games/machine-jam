extends Node


func _ready() -> void:
	await get_tree().process_frame
	%AnimationPlayer.play("RESET")
	%AnimationPlayer.play("open")



func _on_new_game_pressed() -> void:
	SceneTransitionManager.change_scene_with_wipe("res://Prologue.tscn")
	


func _on_parallax_prototype_pressed() -> void:
	get_tree().change_scene_to_file("res://Experiments/DanieleExperiments.tscn")


func _on_cucucc_experiments_pressed() -> void:
	SceneTransitionManager.change_scene_with_wipe("res://Experiments/CucuccExperiments.tscn")
