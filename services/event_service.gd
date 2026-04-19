extends Node
class_name EventService

signal switch_lights_on()
signal item_added(id: String)
signal steam_increase(delta: float)
signal steam_decrease(delta: float)
signal steam_changed(value: float)
signal activate_generator()
signal cabinet_open()
signal pipes_connected(end_position)

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
	activate_generator.connect(_on_activate_generator)
	cabinet_open.connect(_on_cabinet_open)
	

func _on_switch_lights():
	App.game_status.lights_on = true
	await get_tree().create_timer(1).timeout
	await App.show_popup("[color=#f00][b]DANGER! [pause]DANGER! [pause]DANGER![pause][/b][/color]",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("[color=#f00]UNIDENTIFIED ORGANIC STRUCTURE[/color]",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("Human™[pause] your presence here is.[pause=0.5].[pause=0.5].[pause=0.5]\nUnexpected. [pause] Please stand by as our systems find a resolution.",{"close_on_click": true, "title": App.MACHINE_NAME})

func _on_activate_generator():
	App.game_status.generator_active = true
	await App.show_popup("Mmmmmh.[pause=0.5] This is... [pause=0.5] tingly!",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("Are you making yourself comfortable?",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("I hope you are[pause=1] since you'll stay here [color=#f00][b]FOREVER![/b][/color]",{"close_on_click": true, "title": App.MACHINE_NAME})

func _on_cabinet_open():
	await App.show_popup("[color=#f00][b]WHAT ARE [color=#ff0][wave]~bzz~[/wave][/color][pause=0.5][color=#f00] WHAT ARE YOU DOING?!?[/color][/b]",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("[b][color=#f00]THESE [pause]ARE [pause]MINE![/color][/b]",{"close_on_click": true, "title": App.MACHINE_NAME})


func _on_end_game():
	App.ui.close_every_ui()
	var choises : Array[Dictionary] = [
		{
			"text": "Stay here forever...",
			"callable": end_one
		},
		{
			"text": "Leave! Now!!!",
			"callable": end_two
		},
	]
	if App.game_status.secret_ending_unlocked:
		choises.append({
			"text": "Bring him with you! <3",
			"callable": end_three
		})
	await App.show_popup_choise("[color=#f00][b]NOOO![pause] DON'T LEAVE ME!!![/b][/color]", choises)

func end_one():
	await App.show_popup("You stay in here forever... You are his new pet now...", {"close_on_click": true})
	App.hide_popup()
	SceneTransitionManager.change_scene_with_wipe("res://Intro.tscn")

func end_two():
	await App.show_popup("You leave without turning back... while you listen to the machine... crying",  {"close_on_click": true})
	App.hide_popup()
	SceneTransitionManager.change_scene_with_wipe("res://Intro.tscn")

func end_three():
	await App.show_popup("You insert the device in the console... and the machine becomes your new pet! Yey!",  {"close_on_click": true})
	App.hide_popup()
	SceneTransitionManager.change_scene_with_wipe("res://Intro.tscn")
