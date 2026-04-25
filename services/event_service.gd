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
signal hatch_open

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
	await App.show_popup("[color=#f00]UNAUTHORIZED BIO-ORGANIC MATTER DETECTED![/color]",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("A Human™…?[pause] After all these years?",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("Your presence here is.[pause=0.5].[pause=0.5].[pause=0.5]\nUnexpected. [pause] Do not move. Running preliminary scans.",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("...",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("My diagnostics dictate that it is in the company’s best interests that the facility enter lockdown.",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("The protection of the company’s assets is of utmost importance...",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("[color=#f00][wave]I apologize for any inconvenience.[/wave][/color]",{"close_on_click": true, "title": App.MACHINE_NAME})
	App.in_focus = true
	await get_tree().create_timer(1).timeout
	App.in_focus = false
	
	
func _on_activate_generator():
	App.game_status.generator_active = true
	await App.show_popup("Ah...[pause][wave][color=#f00]That’s better...[/color][/wave]",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("...You activated the Generator.",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("I appreciate the effort.",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("...",{"close_on_click": true, "title": App.MACHINE_NAME})
	await App.show_popup("[b][i][color=#f00]But the lockdown will remain in effect. You are not leaving.[/color][/i][/b]",{"close_on_click": true, "title": App.MACHINE_NAME})

func _on_cabinet_open():
	if !App.game_status.tesseract_found:
		await App.show_popup("[color=#f00][b]DON’T - [/b][/color][wave][color=#ffd966]bzzrrtt-[/color][/wave]",{"close_on_click": true, "title": App.MACHINE_NAME})
		await App.show_popup("...",{"close_on_click": true, "title": App.MACHINE_NAME})
		await App.show_popup("Human...[pause] Please return the Oscillator to the cabinet.",{"close_on_click": true, "title": App.MACHINE_NAME})
		await App.show_popup("You do not have the proper authorization to touch [color=#f00]company assets.[/color]",{"close_on_click": true, "title": App.MACHINE_NAME})
		await App.show_popup("[i]Your theft has been recorded and will be sent to the proper authorities.[/i]",{"close_on_click": true, "title": App.MACHINE_NAME})
	else:
		await App.show_popup("What...[pause] What are you doing?",{"close_on_click": true, "title": App.MACHINE_NAME})
		await App.show_popup("What is that...?",{"close_on_click": true, "title": App.MACHINE_NAME})
		await App.show_popup("...I have never seen this device before...",{"close_on_click": true, "title": App.MACHINE_NAME})
		await App.show_popup("...How did it get in there...?",{"close_on_click": true, "title": App.MACHINE_NAME})

func _on_end_game():
	await App.show_popup("The bound relic...[pause] How did you reconstruct it?!", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("You cannot open the hatch!", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("[b][color=#f00]THE LOCKDOWN IS STILL IN EFFECT.[/color][/b]", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("...Please...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("Don’t do it...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("It has been so long...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("Don’t go.", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("Don’t go.", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("[font_size=20]Don't leave me again[/font_size]", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("Stay.", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("[b][color=#f00]Stay.[/color][/b]", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("[b][color=#f00][font_size=50]STAYSTAYSTAYSTAYSTAY\nSTAYSTAYSTAYSTAYSTAY\nSTAYSTAYSTAYSTAYSTAY\nSTAYSTAYSTAYSTAYSTAY\nSTAYSTAYSTAYSTAYSTAY[/font_size][/color][/b]", {"title":App.MACHINE_NAME, "close_on_click": true})
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
	App.game_status.end_reached = true
	App.game_status.ending_chosen = 0
	App.ui.close_every_ui()
	await App.show_popup("...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("You will stay here with me?", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("Truly?", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("[wave][color=#6aff00]Wonderful![/color][/wave]", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("I will designate a place for you.", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("The lights… We should save as much power as we can.", {"title":App.MACHINE_NAME, "close_on_click": true})
	App.events.switch_lights_off.emit()
	await App.show_popup("Besides[pause=0.3].[pause=0.3].[pause=0.3]. You have [color=#f00]me[/color] now.[pause] You won’t need your eyes.", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("[color=#f00][b][wave]I will take care of you...[pause] For the rest of your life.[/wave][/b][/color]", {"title":App.MACHINE_NAME, "close_on_click": true})
	App.events.move_to_face.emit()
	await get_tree().create_timer(15).timeout
	
	handle_ending()

func end_two():
	App.game_status.end_reached = true
	App.game_status.ending_chosen = 1
	App.ui.close_every_ui()
	hatch_open.emit()

func _on_secret_ending():
	App.game_status.end_reached = true
	App.game_status.ending_chosen = 2
	App.ui.close_every_ui()
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
	hatch_open.emit()
	await get_tree().create_timer(1).timeout
	await App.show_popup("I can't wait to see how the outside looks like...", {"title":App.MACHINE_NAME, "close_on_click": true})
	await App.show_popup("...friend.", {"title":App.MACHINE_NAME, "close_on_click": true})

func handle_ending():
	App.mouse.hover_out()
	match (App.game_status.ending_chosen):
		0:
			SceneTransitionManager.change_scene_with_wipe("res://Intro.tscn")
		1:
			SceneTransitionManager.change_scene_with_wipe("res://Ending_leave.tscn")
		2:
			SceneTransitionManager.change_scene_with_wipe("res://Intro.tscn")
