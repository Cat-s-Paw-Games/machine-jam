extends Resource
class_name Item

@export var id : String = "item_id"
@export var name : String = "Item"
@export_multiline var description : String = "Description"
@export var texture : Texture2D
@export var usable_once : bool = false
@export var is_pickable : bool = false
@export var compound : bool = false
@export var material : String = "item_id"
@export var transforms_into : String = "item_id"
@export var station : String = "amenity_id"
@export var station_timer : float = 5.0
@export var shiny := false

func can_be_compound(item_id : String):
	return item_id == material

func can_be_worked(amenity_id : String):
	return amenity_id == station

func transform() -> Item:
	return App.items[transforms_into]
