extends Resource
class_name Amenity

@export var name : String = "Amenity"
@export_multiline var description : String = "Description"
@export var usables : Array[String] = ["item_id"]
@export var active : bool = false

func can_use(item_id : String):
	return item_id in usables

func activate():
	pass
