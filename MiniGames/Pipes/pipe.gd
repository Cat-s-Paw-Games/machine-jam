extends Area2D
class_name Pipe

signal pipe_rotated

enum DIRECTION { UP, RIGHT, DOWN, LEFT }
enum TYPES { STRAIGHT, CORNER, T, CROSS }

@onready var sprite: Sprite2D = $Sprite2D

# IMPORTANT: use INT system only (0–3), not enum values
var connections: Array = []




func set_connections(conns: Array):
	connections = conns.duplicate()
	connections.sort()
	set_pipe()

func set_pipe():
	if connections.size() < 2:
		print("BAD PIPE:", connections)
		sprite.texture = preload("res://assets/images/pipe_game/pipe_1.png")
		sprite.rotation_degrees = 0
		return
	
	
	
	sprite.rotation_degrees = 0

	if connections.is_empty():
		return
	
	connections.sort()
	# --------------------
	# STRAIGHT (pipe_1)
	# UP-DOWN or LEFT-RIGHT
	# --------------------
	if connections == [0, 2]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_1.png")
		sprite.rotation_degrees = 0
		return

	if connections == [1, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_1.png")
		sprite.rotation_degrees = 90
		return

	# --------------------
	# CORNER (pipe_2)
	# must match your sprite orientation
	# image shows: RIGHT + DOWN as base shape
	# --------------------

	if connections == [1, 2]: # RIGHT + DOWN (base orientation)
		sprite.texture = preload("res://assets/images/pipe_game/pipe_2.png")
		sprite.rotation_degrees = 0
		return

	if connections == [2, 3]: # DOWN + LEFT
		sprite.texture = preload("res://assets/images/pipe_game/pipe_2.png")
		sprite.rotation_degrees = 90
		return

	if connections == [0, 3]: # UP + LEFT
		sprite.texture = preload("res://assets/images/pipe_game/pipe_2.png")
		sprite.rotation_degrees = 180
		return

	if connections == [0, 1]: # UP + RIGHT
		sprite.texture = preload("res://assets/images/pipe_game/pipe_2.png")
		sprite.rotation_degrees = 270
		return

	# --------------------
	# T PIPE (pipe_3)
	# YOUR DEFINITION:
	# LEFT + DOWN + RIGHT = missing UP
	# => [1,2,3]
	# --------------------
	if connections == [1, 2, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_3.png")
		sprite.rotation_degrees = 0
		return

	# rotated T variants
	if connections == [0, 2, 3]: # missing RIGHT
		sprite.texture = preload("res://assets/images/pipe_game/pipe_3.png")
		sprite.rotation_degrees = 90
		return

	if connections == [0, 1, 3]: # missing DOWN
		sprite.texture = preload("res://assets/images/pipe_game/pipe_3.png")
		sprite.rotation_degrees = 180
		return

	if connections == [0, 1, 2]: # missing LEFT
		sprite.texture = preload("res://assets/images/pipe_game/pipe_3.png")
		sprite.rotation_degrees = 270
		return


	# --------------------
	# CROSS
	# --------------------
	if connections.size() == 4:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_4.png")
		sprite.rotation_degrees = 0
		return

	# fallback safety
	sprite.texture = preload("res://assets/images/pipe_game/pipe_1.png")
	sprite.rotation_degrees = 0


func rotate_pipe():
	for i in range(connections.size()):
		connections[i] = (connections[i] + 1) % 4

	sprite.rotation_degrees = fmod(sprite.rotation_degrees + 90.0, 360.0)
	pipe_rotated.emit()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		rotate_pipe()
		pipe_rotated.emit()
