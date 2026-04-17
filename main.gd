extends Node

var view_angle : float = 0.0

@export var step : float = 1.0
@export var pano_width : float = 7680.0
@export var fg_width : float = 8000.0
@export var room_width : float = 1920.0
@export var touch_sensitivity : float = 0.5  # Sensibilità dello swipe
signal offset_changed(offset:int)

var touch_start_pos : Vector2 = Vector2.ZERO
var is_touching : bool = false


func _ready() -> void:
	App.start_game()
	var Blackout: PackedScene = preload("res://Rooms/BlackoutOverlay/BlackoutOverlay.tscn")
	var blackout_instance = Blackout.instantiate()
	%GameView.add_child(blackout_instance)
	offset_changed.connect(blackout_instance._on_main_offset_changed)
	App.audio.set_loop_pitch("main", 1.0)
	update_layers(0)

func _process(_delta: float) -> void:
	if App.navigation_enabled:
		var axis = Input.get_axis("ui_left","ui_right")
		view_angle = wrapf(view_angle + axis * step, 0.0, 360.0)
		update_layers(axis)

func update_layers(axis: int):
	%Background.screen_offset.x = (view_angle / 360.0) * pano_width
	%Foreground.screen_offset.x = (view_angle / 360.0) * fg_width
	for chunk in %Rooms.get_children():
		chunk.position.x = fmod((chunk.position.x - axis * step / 360.0 * pano_width) - axis * room_width, pano_width) + axis * room_width
	offset_changed.emit(%Background.screen_offset.x)
