extends Node2D


func _on_switch_pressed() -> void:
	if %Blackout: %Blackout.light_up()
