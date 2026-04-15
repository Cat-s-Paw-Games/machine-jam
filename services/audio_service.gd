extends Node
class_name AudioService

var audio_players:={} # {key: AudioStreamPlayer}
var loop_players:={} # {key: AudioStreamPlayer for loops}

func setup()->void:
	pass

func play(key:String,audio_path:NodePath, config: Dictionary = {})->void:
	if key in audio_players:
		audio_players[key].stop()
	
	var player:=AudioStreamPlayer.new()
	player.stream=load(audio_path)
	add_child(player)
	audio_players[key]=player
	if config.has("volume_db"):
		player.volume_db = config["volume_db"]
	if config.has("pitch"):
		player.pitch_scale = config["pitch"]
	player.play()
	
	await player.finished
	audio_players.erase(key)
	player.queue_free()

func play_loop(key:String,audio_path:NodePath, config: Dictionary = {})->void:
	if key in loop_players:
		return
	
	# Crea un bus con il nome della key se non esiste
	var bus_index = AudioServer.get_bus_index(key)
	if bus_index == -1:
		AudioServer.add_bus()
		bus_index = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(bus_index, key)
		AudioServer.set_bus_send(bus_index, "Master")
	
	var player:=AudioStreamPlayer.new()
	player.stream=load(audio_path)
	player.bus = AudioServer.get_bus_name(bus_index)
	add_child(player)
	loop_players[key]=player
	if config.has("volume_db"):
		player.volume_db = config["volume_db"]
	if config.has("pitch"):
		set_loop_pitch(key,config["pitch"])
	player.play()

func stop_loop(key:String)->void:
	if key in loop_players:
		var player=loop_players[key]
		player.stop()
		loop_players.erase(key)
		player.queue_free()

func stop_all_loops()->void:
	for key in loop_players.keys():
		stop_loop(key)

func set_loop_volume(key:String,volume_db:float)->void:
	if key in loop_players:
		loop_players[key].volume_db=volume_db

func set_loop_pitch(key:String,pitch:float)->void:
	if key in loop_players:
		var bus_index = AudioServer.get_bus_index(key)
		if bus_index == -1:
			return
		
		var pitch_effect = null
		var effect_count = AudioServer.get_bus_effect_count(bus_index)
		
		for i in range(effect_count):
			var effect = AudioServer.get_bus_effect(bus_index, i)
			if effect is AudioEffectPitchShift:
				pitch_effect = effect
				break
		if pitch_effect == null:
			pitch_effect = AudioEffectPitchShift.new()
			AudioServer.add_bus_effect(bus_index, pitch_effect)
		pitch_effect.pitch_scale = pitch
