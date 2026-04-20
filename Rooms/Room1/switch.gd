extends TouchScreenButton

@onready var switch_light: PointLight2D = %SwitchLight

var tween
var start_scale
func _ready():
	start_scale = switch_light.scale
	start_pulse()
	App.events.switch_lights_on.connect(_on_switch_lights_on)

func start_pulse():
	tween = create_tween()
	tween.set_loops() # loop infinito

	tween.tween_property(switch_light, "scale", Vector2(start_scale.x *1.2, start_scale.x *1.2), 1.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(switch_light, "scale", start_scale, 1.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_switch_lights_on():
	texture_normal = preload("res://assets/images/switch_on.png")
	switch_light.color = Color.GREEN
	switch_light.position = Vector2(580,250)
