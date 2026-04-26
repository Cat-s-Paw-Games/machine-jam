extends DropArea

@export var emitter : CPUParticles2D = null

func use_inventory_item(item_id : String) -> bool:
	if item_id == "coal":
		if App.game_status.max_steam < 80:
			var tween = get_tree().create_tween()
			tween.tween_property(emitter,"amount", 48, .5)
			tween.tween_property(emitter,"gravity:y", -600, .5)
			tween.tween_property(emitter,"emission_sphere_radius", 30, .5)
			tween.tween_property(emitter,"scale_amount_min", 1.5, .5)
			tween.tween_property(emitter,"scale_amount_max", 5.5, .5)
			App.game_status.max_steam = 80
		queue_free()
		return true
	return false

func hover_text():
	return "Coal Input"

func _on_mouse_entered() -> void:
	App.mouse.hover_on(self,App.mouse.HOVER_TYPE.INSPECTABLE)

func _on_mouse_exited() -> void:
	App.mouse.hover_out()
