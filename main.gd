extends Node

var view_angle : float = 0.0

@export var step : float = .8
@export var pano_width : float = 7680.0
@export var fg_width : float = 8000.0
@export var room_width : float = 1920.0
@export var touch_sensitivity : float = 0.5  # Sensibilità dello swipe
signal offset_changed(offset:int)

var touch_start_pos : Vector2 = Vector2.ZERO
var is_touching : bool = false
var blackout: CanvasModulate = null


func _ready() -> void:
	App.start_game()
	blackout = CanvasModulate.new()
	blackout.color = Color.from_rgba8(30,30,30,255)
	%GameView.add_child(blackout)
	App.events.switch_lights_on.connect(func(): blackout.queue_free())
	App.audio.stop_loop("main")
	App.audio.play_loop("main","assets/music/dream_catcher.mp3",{"volume_db":-10.0})
	update_layers(0)

func _process(_delta: float) -> void:
	if App.navigation_enabled:
		App.audio.play_loop("walk","res://assets/music/sfx/steps.mp3")
		var axis = Input.get_axis("ui_left","ui_right")
		walk_sfx(axis != 0)
		view_angle = wrapf(view_angle + axis * step, 0.0, 360.0)
		update_layers(axis)
	else:
		App.audio.stop_loop("walk")

func walk_sfx(is_moving):
	var player : AudioStreamPlayer = App.audio.get_loop_player("walk")
	if !player:
		return
	player.volume_linear = 10.0
	
	if is_moving && !player.playing:
		App.audio.play_loop("walk","res://assets/music/sfx/steps.mp3")
	elif !is_moving && player.is_playing:
		App.audio.stop_loop("walk")

func update_layers(axis: int):
	%Background.screen_offset.x = (view_angle / 360.0) * pano_width
	%Foreground.screen_offset.x = (view_angle / 360.0) * fg_width
	for chunk in %Rooms.get_children():
		chunk.position.x = fmod((chunk.position.x - axis * step / 360.0 * pano_width) - axis * room_width, pano_width) + axis * room_width
	offset_changed.emit(%Background.screen_offset.x)
