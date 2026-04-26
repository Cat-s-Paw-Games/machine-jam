extends DropArea

@onready var water_flow_particles: CPUParticles2D = $WaterFlowParticles
@onready var water_impact_particles: CPUParticles2D = $WaterImpactParticles
@onready var timer: Timer = $AudioStreamPlayer2D/Timer
@onready var audio_stream: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var valve_repaired: Node2D = $ValveRepaired

func hover_text():
	if !App.game_status.water_linked:
		return "Broken Pipe"
	return ""

func _on_item_dropped(item : DraggableItem):
	if item is ValveHandle:
		item.queue_free()
		App.mouse.hover_out()
		valve_repaired.visible = true
		$Interact.visible = false


func _on_interact_pressed() -> void:
	App.start_dialogue()
	await App.show_popup("The water is leaking, I need to find something to stop the flow to the leak", {"close_on_click": true})
	App.end_dialogue()


func _on_valve_repaired_pressed() -> void:
	if !App.game_status.water_linked:
		App.audio.play("sfx","res://assets/music/sfx/valve_close.mp3")
		timer.timeout.connect(func(): audio_stream.queue_free())
		timer.start()
		
		var tween = create_tween()
		tween.tween_property(valve_repaired, 'rotation', 0.9, 3)
		tween.play()
		await tween.finished
		water_flow_particles.emitting = false
		water_impact_particles.emitting = false
		App.game_status.water_linked = true
