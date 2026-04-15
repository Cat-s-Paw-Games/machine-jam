extends CenterContainer
class_name PopupContainer

@onready var Text: TypewriterLabel = $PanelContainer/MarginContainer/RichTextLabel 

var text: String:
	get():
		return Text.text
	set(text):
		Text.text = text
		Text.recalc_animation()

func open():
	UIAnimation.animate_pop(self)
	await Text.animation_finished

func close():
	UIAnimation.animate_shrink(self)
