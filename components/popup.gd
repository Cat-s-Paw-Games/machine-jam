extends CenterContainer
class_name PopupContainer

signal clicked()
@onready var Text: TypewriterLabel = $PanelContainer/MarginContainer/RichTextLabel 
@export var close_on_click = false

func _ready() -> void:
	gui_input.connect(_on_gui_input)
	clicked.connect(_on_clicked)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		clicked.emit()

func _on_clicked():
	if not Text.is_animation_finished:
		Text.finish()
	elif close_on_click:
		close()
		

var text: String:
	get():
		return Text.text
	set(text):
		Text.text = text
		Text.recalc_animation()




func open():
	App.navigation_enabled = false
	UIAnimation.animate_pop(self)
	await Text.animation_finished
	if close_on_click: await clicked

func close():
	App.navigation_enabled = true
	UIAnimation.animate_shrink(self)
