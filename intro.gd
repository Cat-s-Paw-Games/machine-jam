extends Node
@onready var light = %EyesLight

var noise := FastNoiseLite.new()
var time := 0.0

func _process(delta):
	time += delta
	var n = noise.get_noise_1d(time)
	light.energy = 0.8 + n * 0.3
	if randf() < 0.05:
		light.visible = !light.visible

func _ready() -> void:
	get_tree().paused = true
	App.audio.play_loop("main","assets/music/beauty_flow.mp3")
	await get_tree().create_timer(2).timeout
	%EyesLight.enabled = true
	noise.frequency = 5.0
	await get_tree().create_timer(2).timeout
	%MainLight1.enabled = true
	%MainLight2.enabled = true
	var tween = create_tween().set_parallel()
	tween.tween_property(%MainLight1,"scale", Vector2(50,50),3)
	tween.tween_property(%MainLight2,"scale", Vector2(50,50),3)
	await  tween.finished
	get_tree().paused = false



func _on_new_game_pressed() -> void:
	SceneTransitionManager.change_scene_with_wipe("res://Prologue.tscn")


func _on_credits_pressed() -> void:
	%CreditsContainer.show()


func _on_close_credits_pressed() -> void:
	%CreditsContainer.hide()


func _on_instructions_pressed() -> void:
	%InstructionsContainer.show()


func _on_close_instructions_pressed() -> void:
	%InstructionsContainer.hide()
