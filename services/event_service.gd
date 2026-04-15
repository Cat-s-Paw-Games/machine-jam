extends Node
class_name EventService

signal switch_lights_on()

func setup():
	switch_lights_on.connect(_on_switch_lights)

func _on_switch_lights():
	App.game_status.lights_on = true
	await get_tree().create_timer(1).timeout
	await App.show_popup("[color=#f00][b]DANGER! [pause]DANGER! [pause]DANGER![pause][/b][/color]")
	await get_tree().create_timer(2).timeout
	App.hide_popup()
	await get_tree().create_timer(1).timeout
	await App.show_popup("[color=#f00]UNIDENTIFIED ORGANIC STRUCTURE[/color]")
	await get_tree().create_timer(2).timeout
	App.hide_popup()
	await get_tree().create_timer(1).timeout
	await App.show_popup("Human™[pause] your presence here is.[pause=0.5].[pause=0.5].[pause=0.5]\nUnexpected. [pause] Please stand by as our systems find a resolution.")
	await get_tree().create_timer(2).timeout
	App.hide_popup()
	
