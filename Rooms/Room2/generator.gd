extends DropArea

@export var fireplace : Node

@onready var steam_bar: ProgressBar = $SteamBar

var has_water = false
var has_fire = false


func _ready() -> void:
	super()
	if is_instance_valid(fireplace):
		fireplace.fire_lit.connect(func(): has_fire = true)

func _process(delta: float) -> void:
	if has_water && has_fire:
		steam_bar.value += delta

func _on_item_dropped(item : DraggableItem):
	if item is Bucket && item.is_full:
		has_water = true
		item.change_to_empty_bucket()
