extends TouchScreenButton

@export var fireplace : Node

var hover = false

func _ready() -> void:
	App.events.activate_generator.connect(func(): $SteamEmitter.emitting = true)

func _process(delta: float) -> void:
	if App.game_status.water_linked && App.game_status.fire_lit:
		if not App.game_status.generator_active: 
			App.events.activate_generator.emit()
		if App.game_status.steam < App.game_status.max_steam:
			App.game_status.steam = App.game_status.steam+delta



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
		App.show_popup(text, {"close_on_click": true})


func _on_pressed() -> void:
	check_state()
