extends Area2D
class_name Pipe

const PIPE_SHADER = preload("uid://wnbvrdexyc60")

signal pipe_rotated

enum DIRECTION { UP, RIGHT, DOWN, LEFT }
enum TYPES { STRAIGHT, CORNER, T, CROSS }

@onready var sprite: Sprite2D = $Sprite2D
@onready var water: Sprite2D = $Water

var connections: Array = []

func _ready() -> void:
	var mat = ShaderMaterial.new()
	mat.shader = PIPE_SHADER
	water.material = mat

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		rotate_pipe()

func set_connections(conns: Array):
	connections = conns.duplicate()
	connections.sort()
	set_pipe()

func set_pipe():
	sprite.rotation_degrees = 0
	if connections.is_empty(): # to edit to implement empty pipe
		return
	
	sprite.texture = preload("res://assets/images/pipe_game/pipe_1.png")
	
	# STRAIGHT - base: UP + DOWN
	if connections == [0, 2]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_1.png")
		sprite.rotation_degrees = 0
		
	
	if connections == [1, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_1.png")
		sprite.rotation_degrees = 90
		
	
	# CORNER - base: RIGHT + DOWN
	if connections == [1, 2]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_2.png")
		sprite.rotation_degrees = 0
		
	
	if connections == [2, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_2.png")
		sprite.rotation_degrees = 90
		
	
	if connections == [0, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_2.png")
		sprite.rotation_degrees = 180
		
	
	if connections == [0, 1]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_2.png")
		sprite.rotation_degrees = 270
		
	
	# T - base: LEFT + DOWN + RIGHT
	if connections == [1, 2, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_3.png")
		sprite.rotation_degrees = 0
		
	
	# rotated T variants
	if connections == [0, 2, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_3.png")
		sprite.rotation_degrees = 90
		
	
	if connections == [0, 1, 3]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_3.png")
		sprite.rotation_degrees = 180
		
	
	if connections == [0, 1, 2]:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_3.png")
		sprite.rotation_degrees = 270
		
	
	# CROSS
	if connections.size() == 4:
		sprite.texture = preload("res://assets/images/pipe_game/pipe_4.png")
		sprite.rotation_degrees = 0
		
	
	water.texture = sprite.texture
	water.rotation_degrees = sprite.rotation_degrees

func rotate_pipe():
	for i in range(connections.size()):
		connections[i] = (connections[i] + 1) % 4
	await rotate_animation()
	water.rotation_degrees = sprite.rotation_degrees
	pipe_rotated.emit()

func rotate_animation():
	var current = round(sprite.rotation_degrees / 90.0) * 90.0
	var target_rotation = current + 90.0
	var tween = create_tween()
	tween.tween_property(sprite, "rotation_degrees", target_rotation, .5)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	await tween.finished

func animate_fill():
	water.show()
	update_pipe_texture()
	var tween = create_tween()
	tween.tween_method(set_progress, 0.0, 1.0, 0.2)

func update_pipe_texture():
	var tex = sprite.texture
	water.material.set_shader_parameter("pipe_mask", tex)

func set_progress(value):
	water.material.set_shader_parameter("progress", value)

func set_flow(dir: Vector2i):
	var rotated_dir = get_rotated_direction(dir)
	water.material.set_shader_parameter("direction", rotated_dir)

func get_rotated_direction(dir: Vector2i) -> Vector2:
	var angle = deg_to_rad(sprite.rotation_degrees)
	var rotated = Vector2(dir.x, dir.y).rotated(angle)
	return rotated
