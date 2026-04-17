extends Node
class_name GameStatusService

var lights_on = false
var fire_lit = false
var water_linked = false
var generator_active = false
var steam := 0.0


func setup():
	pass

func reset():
	lights_on = false
	fire_lit = false
	water_linked = false
	generator_active = false
	steam = 0.0
