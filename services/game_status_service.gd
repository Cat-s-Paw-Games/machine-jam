extends Node
class_name GameStatusService

var lights_on = false
var fire_lit = false
var water_linked = false
var generator_active = false
var steam := 0.0

var game_end = false
var secret_ending_unlocked = false

var oscillator_password = ""
var oscillator_password_inserted = false

func setup():
	pass

func generate_password(key : String, length : int = 3):
	var chars = "1234567890"
	var rnd_pass = ""

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for i in length:
		var index = rng.randi_range(0, chars.length() - 1)
		rnd_pass += chars[index]
	
	match(key):
		"oscillator":
			oscillator_password = rnd_pass

func reset():
	lights_on = false
	fire_lit = false
	water_linked = false
	generator_active = false
	steam = 0.0
	
	game_end = false
	secret_ending_unlocked = false
	
	oscillator_password = ""
	oscillator_password_inserted = false
