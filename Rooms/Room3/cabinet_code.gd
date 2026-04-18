extends Node2D

signal unlock()
var first:int;
var second:int;
var third: int;

var correct_combination = [7,3,9]

func _on_first_count_changed(new_value: int) -> void:
	first = new_value


func _on_second_count_changed(new_value: int) -> void:
	second = new_value


func _on_third_count_changed(new_value: int) -> void:
	third = new_value



func _on_button_pressed() -> void:
	if [first,second,third] == correct_combination:
		App.audio.play("sfx","res://assets/music/sfx/close_door.mp3")
		App.events.cabinet_open.emit()
	else:
		var tween = create_tween()
		var start_pos = %Button.position
		var shake_amount = 3

		for i in range(4):
			tween.tween_property(%Button, "position", start_pos + Vector2(shake_amount, 0), 0.05)
			tween.tween_property(%Button, "position", start_pos + Vector2(-shake_amount, 0), 0.05)
		tween.tween_property(%Button, "position", start_pos, 0.05)
		await tween.finished
