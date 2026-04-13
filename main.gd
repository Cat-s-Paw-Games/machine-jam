extends Node

func _ready() -> void:
	App.audio.play_loop("main","assets/music/main_loop.mp3")
	App.audio.set_loop_volume("main",-10)
