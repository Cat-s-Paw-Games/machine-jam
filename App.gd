extends Node

signal game_end

var MACHINE_NAME = "<machine>"

var mouse:MouseService
var audio:AudioService
var events: EventService
var game_status: GameStatusService
var item_service: ItemService
var ui: UIService
var items: Dictionary
var viewport_size: Vector2
var navigation_enabled:bool = true
var in_focus: bool = false

func _ready()->void:
	viewport_size = get_viewport().size
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
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
	
	item_service=preload("res://services/item_service.gd").new()
	add_child(item_service)
	item_service.setup()
	
	ui=preload("res://services/ui_service.gd").new()
	add_child(ui)
	ui.setup()
	
	items = item_service.items

func start_game():
	App.game_status.reset()
	navigation_enabled = true
#	ui.ui_instance.menu_btn.show()

#func end_game():
	#ui.close_every_ui()
	#get_tree().paused = true
	#navigation_enabled = false
	#game_status.game_end = true
	#var end = preload("res://Experiments/GameEnd.tscn").instantiate()
	#App.ui.add_ui_child(end)

func show_popup(text: String, options: Dictionary = {}):
	var popup: PopupContainer = get_node("/root/UI").find_child("Popup")
	popup.choises = []
	popup.text = text
	var close_on_click = options.get("close_on_click", false)
	var title = options.get("title", "")
	popup.close_on_click = close_on_click
	popup.title = title
	await popup.open()

func show_popup_choise(text: String, choises : Array[Dictionary] = [], options: Dictionary = {}):
	var popup: PopupContainer = get_node("/root/UI").find_child("Popup")
	var close_on_click = options.get("close_on_click", false)
	var title = options.get("title", "")
	popup.close_on_click = close_on_click
	popup.title = title
	popup.choises = choises
	popup.text = text
	await popup.open()

func hide_popup():
	var popup = get_node("/root/UI").find_child("Popup")
	popup.close()

func _process(_delta:float)->void:
	mouse.update_cursor_position()
