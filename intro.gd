extends Node


func _ready() -> void:
	await get_tree().process_frame
	%AnimationPlayer.play("RESET")
	%AnimationPlayer.play("open")



func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	


func _on_parallax_prototype_pressed() -> void:
	get_tree().change_scene_to_file("res://ParallaxPrototype.tscn")
