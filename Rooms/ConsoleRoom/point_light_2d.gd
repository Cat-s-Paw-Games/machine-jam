extends PointLight2D

func _ready() -> void:
	App.events.switch_lights_on.connect(func(): enabled = true)
	var tween = create_tween()
	tween.set_loops() # loop infinito

	tween.tween_property(self, "energy", 4,3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "energy", 0.4, 3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
