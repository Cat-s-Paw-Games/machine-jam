extends Area2D
class_name Pipe

signal pipe_rotated

enum DIRECTION { UP, RIGHT, DOWN, LEFT }
enum TYPES { STRAIGHT, CORNER, T, CROSS }

@onready var sprite: Sprite2D = $Sprite2D

var connections: Array = []

func set_connections(conns: Array):
	connections = conns.duplicate()
	connections.sort()
	set_pipe()

func set_pipe():
	sprite.rotation_degrees = 0
	if connections.is_empty(): # to edit to implement empty pipe
		return
	
	# STRAIGHT - base: UP + DOWN
	if connections == [0, 2]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_1.png")
		sprite.rotation_degrees = 0
		return
	
	if connections == [1, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_1.png")
		sprite.rotation_degrees = 90
		return
	
	# CORNER - base: RIGHT + DOWN
	if connections == [1, 2]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_2.png")
		sprite.rotation_degrees = 0
		return
	
	if connections == [2, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_2.png")
		sprite.rotation_degrees = 90
		return
	
	if connections == [0, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_2.png")
		sprite.rotation_degrees = 180
		return
	
	if connections == [0, 1]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_2.png")
		sprite.rotation_degrees = 270
		return
	
	# T - base: LEFT + DOWN + RIGHT
	if connections == [1, 2, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_3.png")
		sprite.rotation_degrees = 0
		return
	
	# rotated T variants
	if connections == [0, 2, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_3.png")
		sprite.rotation_degrees = 90
		return
	
	if connections == [0, 1, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_3.png")
		sprite.rotation_degrees = 180
		return
	
	if connections == [0, 1, 2]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_3.png")
		sprite.rotation_degrees = 270
		return
	
	# CROSS
	if connections.size() == 4:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_4.png")
		sprite.rotation_degrees = 0
		return
	
	sprite.texture = preload("res://assets/images/pipe_game/pipe_1.png")

func rotate_pipe():
	for i in range(connections.size()):
		connections[i] = (connections[i] + 1) % 4
	sprite.rotation_degrees = fmod(sprite.rotation_degrees + 90.0, 360.0)
	pipe_rotated.emit()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		rotate_pipe()
