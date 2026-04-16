extends DropArea

@export var fireplace : Node

@onready var steam_bar: ProgressBar = $SteamBar

var hover = false

func _ready() -> void:
	super()
	App.events.steam_changed.connect(func(steam): steam_bar.value = steam)

func _process(delta: float) -> void:
	if App.game_status.water_linked && App.game_status.fire_lit:
		if not App.game_status.generator_active: App.events.activate_generator.emit()
		App.events.steam_increase.emit(delta)


func _unhandled_input(event: InputEvent) -> void:
	if App.mouse.is_hovered(self) && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
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
	if text.strip_edges().length() > 0 :
		App.show_popup(text,true)
