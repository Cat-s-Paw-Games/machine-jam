extends DraggableItem
class_name Bucket

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
	item = item.transform()
	set_item()
	is_full = true

func change_to_empty_bucket():
	item = item.transform()
	set_item()
	is_full = false
	full_ratio = 0.0
	global_position = starting_position
