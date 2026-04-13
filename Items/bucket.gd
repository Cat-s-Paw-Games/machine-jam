extends DraggableItem
class_name Bucket

const EMPTY_BUCKET = preload("uid://dqnar0vp1bw07")
const WATER_BUCKET = preload("uid://534rv3scumrs")

@onready var starting_position = global_position
var is_full : bool = false
var full_ratio : float = 0.0
var is_in_puddle : bool = false

func _process_item(delta: float) -> void:
	if !is_full && is_in_puddle && full_ratio < .99:
		full_ratio += delta
		if full_ratio >= 1.0:
			change_to_full_bucket()

func change_to_full_bucket():
	texture_normal = WATER_BUCKET
	is_full = true

func change_to_empty_bucket():
	texture_normal = EMPTY_BUCKET
	is_full = false
	full_ratio = 0.0
	global_position = starting_position
