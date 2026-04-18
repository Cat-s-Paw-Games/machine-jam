extends VBoxContainer

signal count_changed(new_value: int)

@export var value: int = 0

func _ready() -> void:
	set_value()

func set_value():
	$Number.text = str(value)
	count_changed.emit(value)

func _on_plus_pressed() -> void:
	value = (value + 1) % 10
	set_value()


func _on_minus_pressed() -> void:
	if value == 0: value = 9
	else: value -= 1
	set_value()
