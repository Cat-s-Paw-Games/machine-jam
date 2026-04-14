extends Node2D

var view_angle := 0.0

@export var step := 1.0
@export var pano_width := 7680.0
@export var fg_width := 8000.0

signal offset_changed(offset:int)
@export var light_world_x := 2500.0
@export var light_screen_y := 0.5
@onready var bg := $CanvasLayer/Background
@onready var fg := $CanvasLayer/Foreground
@onready var rooms = $CanvasLayer/Rooms.get_children()
@onready var shadow_overlay := $Blackout/ColorRect

func _ready():
	update_layers()

func _process(_delta: float) -> void:
	var axis = Input.get_axis("ui_left","ui_right")
	view_angle = wrapf(view_angle + axis * step, 0.0, 360.0)
	update_layers()


	for chunk in rooms:
		var new_pos = fmod((chunk.position.x - axis * step / 360.0 * pano_width) - axis * 1920.0, pano_width) + axis * 1920.0
		chunk.position.x = new_pos
		


func angle_to_offset(angle: float, width: float) -> float:
	return (angle / 360.0) * width

func update_layers():
	bg.screen_offset.x = angle_to_offset(view_angle, pano_width)
	fg.screen_offset.x = angle_to_offset(view_angle, fg_width)
	offset_changed.emit(bg.screen_offset.x)
