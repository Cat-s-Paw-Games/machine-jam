extends Area2D
class_name HoverHint


@export var text : String

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if App.mouse.hover_type != MouseService.HOVER_TYPE.INVENTORY_DROP:
		App.mouse.hover_on(self, MouseService.HOVER_TYPE.DROPPABLE)

func _on_mouse_exited() -> void:
	if App.mouse.hover_type != MouseService.HOVER_TYPE.INVENTORY_DROP:
		App.mouse.hover_out()

	

func hover_text():
	return text
