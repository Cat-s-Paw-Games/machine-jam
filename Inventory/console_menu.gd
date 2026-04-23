extends VBoxContainer

signal floppy_saved
signal play_card_game

@export var main_screen : Node = null

var paused = false
var correct_item = false
var floppy_log = false
var current_floppy = null
var background = "#3c630f"
var foreground = "#ffffff"
var current_line = 0;
var screens = {
	"main_menu":  {
		"lines": [
			"[EMERGENCY HATCH] Open",
			"Logs"
		],
	},
	"open_fail":  {
		"lines": [
			"Back"
		],
	},
	"open_success":  {
	},
	"logs": {
		"lines": [
			"Back",
		],
	}
}
var current_screen = "main_menu"

var lines: 
	get():
		return screens[current_screen].get("lines",[])
var pretext:
	get():
		return screens[current_screen].get("pretext","")

func get_next_screen():
	match current_screen:
		"main_menu":
			if current_line == 0 and not correct_item: return "open_fail"
			if current_line == 0 and correct_item: return "open_success"
			elif current_line == 1: return "logs"
			elif current_line == 2 and !App.game_status.card_game_uploaded and !floppy_log:
				install_card_minigame()
			elif current_line == 2 and App.game_status.card_game_uploaded:
				play_card_game.emit()
			elif (current_line == 2 and !App.game_status.card_game_uploaded or current_line == 3) and floppy_log:
				save_floppy_data()
				var keys = App.game_status.console_logs.keys()
				return keys[keys.size() - 1]
			elif current_line == 3 and !floppy_log and App.game_status.tesseract_found:
				secret_ending()
		"open_fail":
			if current_line == 0: return "main_menu"
		"logs":
			if current_line == 0: return "main_menu"
			else:
				return App.game_status.console_logs.keys()[current_line - 1]
		_:
			if current_line == 0: return "logs"

func install_card_minigame():
	App.game_status.card_game_uploaded = true
	current_floppy = null
	floppy_saved.emit()
	load_data()

func save_floppy_data():
	if floppy_log && current_floppy != null:
		App.game_status.console_logs[current_floppy.id] = {}
		var pretext_start = current_floppy.description.find("[pretext]")
		var pretext_end = current_floppy.description.find("[/pretext]")
		var _pretext = current_floppy.description.substr(pretext_start, pretext_end + "[/pretext]".length())
		_pretext = _pretext.replace("[pretext]", "").replace("[/pretext]", "")
		
		var content_start = current_floppy.description.find("[content]")
		var content_end = current_floppy.description.find("[/content]")
		var _content = current_floppy.description.substr(content_start, content_end + "[/content]".length())
		_content = _content.replace("[content]", "").replace("[/content]", "").replace("[MACHINE_NAME]", App.MACHINE_NAME)
		App.game_status.console_logs[current_floppy.id] = {"line": current_floppy.name, "pretext": _pretext + "\n" + _content}
	
	floppy_log = false
	current_floppy = null
	load_data()
	main_screen.load_data()
	floppy_saved.emit()

func _ready() -> void:
	load_data()
	render()

func load_data():
	var supercharge_line = "Supercharge"
	if App.game_status.card_game_uploaded && !screens["main_menu"]["lines"].has(supercharge_line):
		screens["main_menu"]["lines"].append(supercharge_line)
	
	var back_line = "Back"
	screens["logs"]["lines"].clear()
	screens["logs"]["lines"].append(back_line)
	for log_id in App.game_status.console_logs:
		screens[log_id] = App.game_status.console_logs[log_id]
		screens[log_id]["lines"] = []
		screens[log_id]["lines"].append("Back")
		screens["logs"]["lines"].append(App.game_status.console_logs[log_id].line)

func create_label(text : String) -> Label:
	var label : Label = Label.new()
	label.add_theme_font_size_override("font_size", 18)
	label.set_meta("text", text)
	label.text = text
	return label
	
func render():
	for c in get_children():
		c.queue_free()
	
	var i = 0
	for l in lines:
		var label = create_label(l)
		label.text = "> %s" % l if i == current_line else l
		i += 1
		add_child(label)
	if current_screen == "open_success":
		paused = true
		await get_tree().create_timer(3).timeout
		App.events._on_end_game()

func _input(event: InputEvent) -> void:
	if paused: return
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_DOWN:
				if lines.size() > 0:
					current_line = (current_line + 1) % lines.size()
					render()
			KEY_UP:
				if lines.size() > 0:
					current_line = (current_line - 1 + lines.size()) % lines.size()
					render()
			KEY_ENTER:
				var next_screen = get_next_screen()
				if next_screen:
					current_screen = next_screen
				else:
					current_screen = "main_menu"
				current_line = 0
				render()
				if main_screen:
					main_screen.current_screen = current_screen
					main_screen.render()

func secret_ending():
	App.game_status.secret_ending_unlocked = true
	print("SECRET ENDING")
	App.events.secret_ending.emit()
