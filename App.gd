extends Node

var mouse:MouseService
var audio:AudioService
var events: EventService

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

func _process(_delta:float)->void:
	mouse.update_cursor_position()
