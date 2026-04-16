extends DropArea

@export var fireplace : Node

@onready var steam_bar: ProgressBar = $SteamBar

var hover = false

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


func _on_mouse_entered() -> void:
	hover = true


func _on_mouse_exited() -> void:
	hover = false

func _unhandled_input(event: InputEvent) -> void:
	if hover && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		check_state()

func check_state():
	var text = ""
	var checks = [has_water, has_fire]
	if false in checks:
		text += "Checks failed:"
	if !has_water:
		text += "\n- Water Missing"
	if !has_fire:
		text += "\n- Fire Missing"
	GameManager.popup.text = text
	GameManager.popup.open()
