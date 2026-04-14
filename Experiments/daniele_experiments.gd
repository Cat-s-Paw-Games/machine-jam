extends Node2D

@onready var camera := get_viewport().get_camera_2d()
@onready var rooms = $Rooms.get_children()
@export var chunk_width: float = 1920.0

var margin = 10.0
func _process(delta):
	if camera == null:
		return

	var axis = Input.get_axis("ui_left","ui_right")
	
	camera.position.x += axis * 500 * delta
	
	#var threshold = get_viewport_rect().size.x / 4
	
	

	var cam_x = camera.global_position.x

	# 1. Apply parallax offset
	#global_position.x = cam_x

	# 2. Wrap chunks
	for chunk in rooms:
		var chunk_global_x = chunk.global_position.x
		
		if chunk_global_x + chunk_width < cam_x - margin:
			chunk.global_position.x += chunk_width * rooms.size()
		
		elif chunk_global_x - chunk_width > cam_x + margin:
			chunk.global_position.x -= chunk_width * rooms.size()
