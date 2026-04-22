extends CenterContainer
class_name PopupContainer

signal clicked()
@onready var Text: TypewriterLabel = %RichTextLabel
@onready var buttons: HBoxContainer = %Buttons
@export var close_on_click = false
@export var title = ""

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


var choises : Array[Dictionary] = []:
	set(new_val):
		choises = new_val
		buttons.hide()
		if is_node_ready():
			if choises.size() > 0:
				buttons.show()
				set_buttons()

func set_buttons():
	for child in buttons.get_children():
		child.queue_free()
	
	for choise in choises:
		var btn = Button.new()
		btn.text = choise.text
		btn.pressed.connect(func(): close(); choise.callable.call())
		buttons.add_child(btn)


func open():
	App.navigation_enabled = false
	App.in_focus = true
	%Title.visible = title.strip_edges().length() > 0
	%Title.text = title
	UIAnimation.animate_pop(self)
	await Text.animation_finished
	if choises.size() > 0:
		set_buttons()
	if close_on_click: await clicked

func close():
	await UIAnimation.animate_shrink(self)
	App.navigation_enabled = true
	App.in_focus = false
