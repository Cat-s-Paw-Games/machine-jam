extends PointLight2D

@export var energy_off_min = 0
@export var energy_off_max = 0
@export var energy_on_min = 1
@export var energy_on_max = 1
@export var loop_duration = 1


var light_up = false
var light_loop


func _ready() -> void:
	start_loop(energy_off_min,energy_off_max)

func start_on_loop():
	stop_loop()
	start_loop(energy_on_min,energy_on_max)
	
func start_off_loop():
	stop_loop()
	start_loop(energy_off_min,energy_off_max)

func stop_loop():
	if light_loop != null:
		light_loop.stop()
	light_loop = null

func start_loop(base_energy_min,base_energy_max):
	light_loop = create_tween()
	light_loop.set_loops() # loop infinito

	light_loop.tween_property(self, "energy", base_energy_max ,loop_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	light_loop.tween_property(self, "energy", base_energy_min , loop_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
