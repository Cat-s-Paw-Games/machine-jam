extends Node

var view_angle : float = 0.0

@export var step : float = .8
@export var pano_width : float = 7680.0
@export var fg_width : float = 8000.0
@export var room_width : float = 1920.0
@export var touch_sensitivity : float = 0.5  # Sensibilità dello swipe
@export var mouse_edge_size := 80.0

signal offset_changed(offset:int)

var touch_start_pos : Vector2 = Vector2.ZERO
var is_touching : bool = false
var blackout: Blackout = null


func _ready() -> void:
	App.start_game()
	blackout = Blackout.new()
	%GameView.add_child(blackout)
	App.events.move_to_face.connect(func() : move_to_angle(135.0, 1.5))
	App.audio.stop_loop("main")
	App.audio.play_loop("main","assets/music/dream_catcher.mp3",{"volume_db":-10.0})
	update_layers(0)
	move_to_angle(100)


func _process(_delta: float) -> void:
	if App.navigation_enabled:
		
		var axis := Input.get_axis("ui_left","ui_right")
		var mouse_x := get_viewport().get_mouse_position().x
		var viewport_width := get_viewport().get_visible_rect().size.x

		if mouse_x <= mouse_edge_size:
			axis = -1.0
		elif mouse_x >= viewport_width - mouse_edge_size:
			axis = 1.0

		view_angle = wrapf(view_angle + axis * step, 0.0, 360.0)
		update_layers(axis)

func update_layers(axis: int):
	%Background.screen_offset.x = (view_angle / 360.0) * pano_width
	%Foreground.screen_offset.x = (view_angle / 360.0) * fg_width
	for chunk in %Rooms.get_children():
		chunk.position.x = fmod((chunk.position.x - axis * step / 360.0 * pano_width) - axis * room_width, pano_width) + axis * room_width
	offset_changed.emit(%Background.screen_offset.x)

func move_to_angle(target_angle: float = 135.0, duration: float = 1.5):
	var delta = view_angle - target_angle

	if delta > 0:
		while view_angle - target_angle  > 0:
			var axis = -1
			view_angle = wrapf(view_angle + axis * step, 0.0, 360.0)
			update_layers(axis)
			await(get_tree().create_timer(step * duration / 360.0).timeout)
	elif delta < 0:
		while view_angle - target_angle  < 0:
			var axis = 1
			view_angle = wrapf(view_angle + axis * step, 0.0, 360.0)
			update_layers(axis)
			await(get_tree().create_timer(step * duration / 360.0).timeout)
