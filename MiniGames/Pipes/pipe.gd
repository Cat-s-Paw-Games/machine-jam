extends Area2D
class_name Pipe

const PIPE_SHADER = preload("res://MiniGames/Pipes/pipe.gdshader")

signal pipe_rotated

enum DIRECTION { UP, RIGHT, DOWN, LEFT }
enum TYPES { STRAIGHT, CORNER, T, CROSS }

@onready var sprite: Sprite2D = $Sprite2D
@onready var water: Sprite2D = $Water
var enabled = true

var connections: Array = []

func shake():

	var tween = create_tween()
	var start_pos = position
	var shake_amount = 3

	for i in range(4):
		tween.tween_property(self, "position", start_pos + Vector2(shake_amount, 0), 0.02)
		tween.tween_property(self, "position", start_pos + Vector2(-shake_amount, 0), 0.02)
	tween.tween_property(self, "position", start_pos, 0.02)
	await tween.finished
	
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if enabled and event and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			rotate_pipe(1)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			rotate_pipe(-1)

func set_connections(conns: Array):
	connections = conns.duplicate()
	connections.sort()
	set_pipe()

func set_pipe():
	sprite.rotation_degrees = 0
	sprite.texture = preload("res://assets/images/pipe_game/pipe_1.png")
	if connections.is_empty(): # to edit to implement empty pipe
		sprite.texture = preload("res://build/empty.png")
		sprite.rotation_degrees = 0
	
	
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

func rotate_pipe(direction : int = 1):
	if App.in_focus: return
	if not enabled: return
	if not App.game_status.pipe_touched: 
		App.start_dialogue()
		await App.show_popup("There's something rattling inside these pipes", {
			"close_on_click": true
		})
		App.end_dialogue()
		App.game_status.pipe_touched = true
		return
	var tracks = ["res://assets/music/sfx/metal_squeak_1.mp3", "res://assets/music/sfx/metal_squeak_2.mp3", "res://assets/music/sfx/metal_squeak_3.mp3"]
	var track_idx = randi_range(0,2)
	App.audio.play("sfx",tracks[track_idx],{"volume_db": 3})
	for i in range(connections.size()):
		connections[i] = (connections[i] + direction + 4) % 4
	await rotate_animation(direction)
	pipe_rotated.emit()

func rotate_animation(direction : int):
	var current = round(sprite.rotation_degrees / 90.0) * 90.0
	var target_rotation = current + 90.0 * direction
	var tween = create_tween()
	tween.tween_property(sprite, "rotation_degrees", target_rotation, .5)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	await tween.finished
