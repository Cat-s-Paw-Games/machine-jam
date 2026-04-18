extends Node

var enabled: bool = false
var cheats: bool = false
var verbose_logs: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	enabled = OS.has_feature("editor")
	cheats = enabled
	verbose_logs = enabled
	print("[DEV] Enabled:", enabled)

func _unhandled_input(event: InputEvent) -> void:
	if enabled:
		if event is InputEventKey and event.keycode == KEY_F5 and event.pressed:
			SceneTransitionManager.change_scene_with_wipe("res://main.tscn")
			get_tree().paused = false
			
		if event is InputEventKey and event.keycode == KEY_F1 and event.pressed:
			App.game_status.fire_lit = true
			App.game_status.water_linked = true
			App.game_status.generator_active = true
			App.game_status.steam += 100
		
		if event is InputEventKey and event.keycode == KEY_M and event.pressed:
			var master = AudioServer.get_bus_index("Master")
			AudioServer.set_bus_mute(master, true)
