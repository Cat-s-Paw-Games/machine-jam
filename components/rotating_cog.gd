extends Sprite2D
class_name RotatingCog

@export var speed := 1.0
enum RotationType {
	CLOCKWISE,
	COUNTERCLOCKWISE
}
@export var rotation_type := RotationType.CLOCKWISE

func _process(delta):
	if rotation_type == RotationType.CLOCKWISE:
		rotation += speed * delta
	else:
		rotation -= speed * delta
