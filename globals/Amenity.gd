extends Resource
class_name Amenity

@export var name : String = "Amenity"
@export_multiline var description : String = "Description"
@export_custom(PROPERTY_HINT_ARRAY_TYPE, "Item") var usables : Array = []
@export var active : bool = false

func can_use(item : Item):
	return item in usables

func activate():
	pass
