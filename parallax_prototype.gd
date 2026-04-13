extends Node2D

var is_blocked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta):
	var axis = Input.get_axis("ui_left","ui_right")
	
	if $Camera2D.position.x > 1920 && axis >= 1:
		return
	
	$Camera2D.position.x += axis * 500 * delta


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		is_blocked = true
