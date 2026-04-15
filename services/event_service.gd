extends Node
class_name EventService

signal switch_lights_on()

func setup():
	switch_lights_on.connect(func () : App.game_status.lights_on = true)
	pass
