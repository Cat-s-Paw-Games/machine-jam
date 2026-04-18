extends TouchScreenButton

var tween
var start_scale
func _ready():
	start_scale = %SwitchLight.scale
	start_pulse()
	App.events.switch_lights_on.connect(func(): 
		texture_normal = preload("res://assets/images/switch_on.png")
		%SwitchLight.color = Color.GREEN
	)

func start_pulse():
	tween = create_tween()
	tween.set_loops() # loop infinito

	tween.tween_property(%SwitchLight, "scale", Vector2(start_scale.x *1.2, start_scale.x *1.2), 1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(%SwitchLight, "scale", start_scale, 1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
