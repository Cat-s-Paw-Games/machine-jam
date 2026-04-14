extends Resource
class_name Item

@export var name : String = "Item"
@export_multiline var description : String = "Description"
@export var reusable : bool = false
@export var compound : bool = false
@export_custom(PROPERTY_HINT_ARRAY_TYPE, "Item") var materials : Array = []
@export_custom(PROPERTY_HINT_ARRAY_TYPE, "Amenity") var usable_on : Array = [] #Assets? which name is better?


func can_be_used(amenity : Amenity):
	return amenity in usable_on

func can_be_compound(item : Item):
	return item in materials
