extends Resource
class_name Item

@export var name : String = "Item"
@export_multiline var description : String = "Description"
@export var reusable : bool = false
@export var compound : bool = false
@export_custom(PROPERTY_HINT_ARRAY_TYPE, "Item") var materials : Array = []

func can_be_compound(item : Item):
	return item in materials
