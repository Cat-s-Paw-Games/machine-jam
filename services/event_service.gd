extends Node
class_name EventService

signal switch_lights_on()
signal switch_lights_off()
signal flashlight_on()
signal flashlight_off()
signal move_to_face()
signal item_added(id: String)
signal activate_generator()
signal cabinet_open()
signal pipes_connected(end_position)
signal secret_ending()

func setup():
	switch_lights_on.connect(_on_switch_lights)
	activate_generator.connect(_on_activate_generator)
	cabinet_open.connect(_on_cabinet_open)
	secret_ending.connect(_on_secret_ending)
	

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
	App.events.move_to_face.emit()
	await get_tree().create_timer(15).timeout
	SceneTransitionManager.change_scene_with_wipe("res://Intro.tscn")

	
func end_two():
	SceneTransitionManager.change_scene_with_wipe("res://Ending_leave.tscn")

func _on_secret_ending():
	await App.show_popup("What?", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("What's this?", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("I'm feeling...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("I'm getᵗᶦⁿᵍ ˢᵐᵃᵃˡˡ", {"title":App.MACHINE_NAME, "close_on_click": true})
	await get_tree().create_timer(3).timeout
	App.events.switch_lights_off.emit()

	App.MACHINE_NAME = "<portable machine>"
	await App.show_popup("Are you... taking me with you?", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("We can stay together?", {"title":App.MACHINE_NAME, "close_on_click": true})
	await get_tree().create_timer(1).timeout
	await App.show_popup("It's so dark in here.", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("Let me be your light", {"title":App.MACHINE_NAME, "close_on_click": true})
	App.events.flashlight_on.emit()
	await get_tree().create_timer(1).timeout
	await App.show_popup("I'm still connected?", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("Yes, yes I am.", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("Let me open the hatch.", {"title":App.MACHINE_NAME, "close_on_click": true})
	await get_tree().create_timer(1).timeout
	await App.show_popup("I can't wait to see how the outside looks like...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("...friend.", {"title":App.MACHINE_NAME, "close_on_click": true})

	
