extends DropArea



func _on_gui_input():
	pass

func _on_item_dropped(item : DraggableItem):
	if item is ValveHandle:
		item.queue_free()
		App.mouse.hover_out()
		$ValveRepaired.visible = true
		$Interact.visible = false
		




func _on_interact_pressed() -> void:
	App.show_popup("The water is flowing, but there's nothing to stop the flow.",true)


func _on_valve_repaired_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($ValveRepaired, 'rotation', 0.9, 3)
	tween.play()
	await tween.finished
	$CPUParticles2D.emitting = false
