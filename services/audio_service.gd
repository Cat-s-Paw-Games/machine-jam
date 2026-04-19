extends Node
class_name AudioService

var audio_players := {}      # { key: AudioStreamPlayer }
var loop_players := {}       # { key: AudioStreamPlayer }
var stream_cache := {}       # { path: AudioStream }

func setup():
	pass

func get_stream(path: String) -> AudioStream:
	if !stream_cache.has(path):
		stream_cache[path] = load(path)
	return stream_cache[path]

func play(key: String, audio_path: String, config: Dictionary = {}) -> void:
	var player: AudioStreamPlayer

	if audio_players.has(key):
		player = audio_players[key]
		player.stop()
	else:
		player = AudioStreamPlayer.new()
		add_child(player)
		audio_players[key] = player

	player.stream = get_stream(audio_path)

	if config.has("volume_db"):
		player.volume_db = config["volume_db"]
	if config.has("pitch"):
		player.pitch_scale = config["pitch"]

	player.play()

func stop(key: String) -> void:
	if audio_players.has(key):
		var player: AudioStreamPlayer = audio_players[key]
		audio_players.erase(key)
		player.stop()
		player.queue_free()

func play_loop(key: String, audio_path: String, config: Dictionary = {}) -> void:
	if loop_players.has(key):
		return

	create_loop_player(key)
	var player: AudioStreamPlayer = loop_players[key]
	player.stream = get_stream(audio_path)

	if config.has("volume_db"):
		player.volume_db = config["volume_db"]

	player.play()

func create_loop_player(key: String) -> void:
	if !loop_players.has(key):
		var player := AudioStreamPlayer.new()
		player.bus = "Master" # oppure un bus fisso tipo "Loops"
		add_child(player)
		loop_players[key] = player

func stop_loop(key: String) -> void:
	if loop_players.has(key):
		var player: AudioStreamPlayer = loop_players[key]
		loop_players.erase(key)
		player.stop()
		player.queue_free()

func stop_all_loops() -> void:
	for key in loop_players.keys():
		stop_loop(key)
