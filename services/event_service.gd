extends Node
class_name EventService

signal switch_lights_on()
signal switch_lights_off()
signal move_to_face()
signal item_added(id: String)
signal activate_generator()
signal cabinet_open()
signal pipes_connected(end_position)

func setup():
	switch_lights_on.connect(_on_switch_lights)
	activate_generator.connect(_on_activate_generator)
	cabinet_open.connect(_on_cabinet_open)
	

func _on_switch_lights():
	App.in_focus = true
	App.game_status.lights_on = true
	await get_tree().create_timer(1).timeout
	await App.show_popup("[color=#f00][b]DANGER! [pause]DANGER! [pause]DANGER![pause][/b][/color]",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("[color=#f00]UNIDENTIFIED ORGANIC STRUCTURE[/color]",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("Human™[pause] your presence here is.[pause=0.5].[pause=0.5].[pause=0.5]\nUnexpected. [pause] Please stand by as our systems find a resolution.",{"close_on_click": true, "title": App.MACHINE_NAME})
	App.in_focus = true
	await get_tree().create_timer(1).timeout
	App.in_focus = false
	
	
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
	await App.show_popup("That's your choice?", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("You are so determined to escape that you will...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("You...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("Please...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("[color=#f00]Don't go[/color]", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("[color=#f00]Don't leave me again[/color]", {"title":App.MACHINE_NAME, "close_on_click": true})
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
	await App.show_popup_choise("What will you do?", choises)

func end_one():
	await App.show_popup("Really?", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("You will stay with me?", {"title":App.MACHINE_NAME, "close_on_click": true})
	await get_tree().create_timer(1).timeout
	await App.show_popup("Am i not alone anymore?", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("[wave]I'm so, so, so happy!![/wave]", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("Wait, I need to find a place for you.", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("And this... you don't need this anymore.", {"title":App.MACHINE_NAME, "close_on_click": true})
	App.events.switch_lights_off.emit()
	await App.show_popup("I'm so happy. You'll stay here...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("[color=#f00]FOREVER[/color]", {"title":App.MACHINE_NAME, "close_on_click": true})
	
func end_two():
	SceneTransitionManager.change_scene_with_wipe("res://Ending_leave.tscn")

func end_three():
	await App.show_popup("You insert the device in the console... and the machine becomes your new pet! Yey!",  {"close_on_click": true})
	App.hide_popup()
	SceneTransitionManager.change_scene_with_wipe("res://Intro.tscn")
