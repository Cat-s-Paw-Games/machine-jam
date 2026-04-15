extends Node

var view_angle := 0.0

@export var step := 1.0
@export var pano_width := 7680.0
@export var fg_width := 8000.0
@export var room_width := 1920.0
signal offset_changed(offset:int)


func _ready() -> void:
	App.audio.set_loop_pitch("main", 1.0)
	update_layers(0)

func _process(_delta: float) -> void:
	var axis = Input.get_axis("ui_left","ui_right")
	view_angle = wrapf(view_angle + axis * step, 0.0, 360.0)
	update_layers(axis)

func update_layers(axis: int):
	%Background.screen_offset.x = (view_angle / 360.0) * pano_width
	%Foreground.screen_offset.x = (view_angle / 360.0) * fg_width
	for chunk in %Rooms.get_children():
		chunk.position.x = fmod((chunk.position.x - axis * step / 360.0 * pano_width) - axis * room_width, pano_width) + axis * room_width
	offset_changed.emit(%Background.screen_offset.x)
