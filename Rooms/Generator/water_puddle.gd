extends DropArea

const PUDDLE = preload("uid://jgjwwbjwho17")

func _ready() -> void:
	amenity = PUDDLE

func _on_item_dropped(item : DraggableItem):
	if item is Bucket:
		item.is_in_puddle = true


func _on_item_exited(item: DraggableItem):
	if item is Bucket:
		item.is_in_puddle = false
