extends Node
class_name AudioService

var audio_players:={} # {key: AudioStreamPlayer}
var loop_players:={} # {key: AudioStreamPlayer for loops}

func setup()->void:
	pass

func play(key:String,audio_path:NodePath)->void:
	if key in audio_players:
		audio_players[key].stop()
	
	var player:=AudioStreamPlayer.new()
	player.stream=load(audio_path)
	add_child(player)
	player.play()
	audio_players[key]=player
	
	await player.finished
	audio_players.erase(key)
	player.queue_free()

func play_loop(key:String,audio_path:String)->void:
	if key in loop_players:
		return
	
	var player:=AudioStreamPlayer.new()
	player.stream=load(audio_path)
	player.bus=&"Music" if ResourceLoader.exists("res://assets/music/") else &"Master"
	add_child(player)
	player.play()
	loop_players[key]=player

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
