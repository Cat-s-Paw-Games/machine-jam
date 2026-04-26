extends CanvasModulate
class_name Blackout

var flicker_time := 0.0
var flicker_duration := 2.0
var flickering := false

func _ready() -> void:
	color = Color.from_rgba8(30,30,30,255)
	App.events.switch_lights_on.connect(_on_light_on)
	App.events.switch_lights_off.connect(_on_light_off)

func _process(delta):
	if not flickering:
		return
	flicker_time += delta
	if randf() < 0.1 * flicker_time:
		visible = false
	else:
		visible = true

	if flicker_time >= flicker_duration:
		flickering = false
		visible = false

func _on_light_on():
	flicker_time = 0.0
	flickering = true
	visible = true

func _on_light_off():
	flickering = false
	visible = true
	color.a = 1.0
