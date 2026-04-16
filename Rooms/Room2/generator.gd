extends DropArea

@export var fireplace : Node

@onready var steam_bar: ProgressBar = $SteamBar

var hover = false

func _process(delta: float) -> void:
	if App.game_status.water_linked && App.game_status.fire_lit:
		steam_bar.value += delta

func _on_mouse_entered() -> void:
	hover = true

func _on_mouse_exited() -> void:
	hover = false

func _unhandled_input(event: InputEvent) -> void:
	if hover && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		check_state()

func check_state():
	var text = ""
	var checks = [App.game_status.fire_lit, App.game_status.water_linked]
	if false in checks:
		text += "Checks failed:"
	if !App.game_status.water_linked:
		text += "\n- Water Missing"
	if !App.game_status.fire_lit:
		text += "\n- Fire Missing"
	GameManager.popup.text = text
	GameManager.popup.open()
