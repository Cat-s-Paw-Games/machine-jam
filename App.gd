extends Node

var mouse:MouseService
var audio:AudioService
var events: EventService
var game_status: GameStatusService

func _ready()->void:
	mouse=preload("res://services/mouse_service.gd").new()
	add_child(mouse)
	mouse.setup()
	
	audio=preload("res://services/audio_service.gd").new()
	add_child(audio)
	audio.setup()
	
	events=preload("res://services/event_service.gd").new()
	add_child(events)
	events.setup()
	
	game_status=preload("res://services/game_status_service.gd").new()
	add_child(game_status)
	game_status.setup()

func _process(_delta:float)->void:
	mouse.update_cursor_position()
