extends Node
class_name EventService

signal switch_lights_on()
signal item_added(id: String)
signal steam_increase(delta: float)
signal steam_decrease(delta: float)
signal steam_changed(value: float)
signal activate_generator()

func setup():
	switch_lights_on.connect(_on_switch_lights)
	steam_increase.connect(func(delta): 
		App.game_status.steam += delta
		steam_changed.emit(App.game_status.steam)
	)
	steam_decrease.connect(func(delta): 
		App.game_status.steam -= delta
		steam_changed.emit(App.game_status.steam)
	)
	activate_generator.connect(func(): App.game_status.generator_active = true)

func _on_switch_lights():
	App.game_status.lights_on = true
	await get_tree().create_timer(1).timeout
	await App.show_popup("[color=#f00][b]DANGER! [pause]DANGER! [pause]DANGER![pause][/b][/color]",true)
	await App.show_popup("[color=#f00]UNIDENTIFIED ORGANIC STRUCTURE[/color]",true)
	await App.show_popup("Human™[pause] your presence here is.[pause=0.5].[pause=0.5].[pause=0.5]\nUnexpected. [pause] Please stand by as our systems find a resolution.",true)
