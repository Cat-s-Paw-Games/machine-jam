extends VBoxContainer

var paused = false
var correct_item = false
var background = "#3c630f"
var foreground = "#ffffff"
var current_line = 0;
var screens = {
	"main_menu":  {
		"lines": [
			"> [EMERGENCY HATCH] Open",
			"> Logs"
		],
		"pretext" :"Welcome to %s CONTROL PANEL." % App.MACHINE_NAME
	},
	"open_fail":  {
		"lines": [
			"> Back"
		],
		"pretext" :"Bound Core missing. Emergency procedure unavailable" 
	},
	"open_success":  {
		"pretext" :"Emergency procedure initiatied" 
	},
	"logs": {
		"lines": [
			"> Back",
			"> Log Entry 91721.00",
			"> Log Entry 91721.15",
			"> Log Entry 91721.92",
			"> Log Entry 91722.38",
			"> Log Entry 91722.94",
			"> Log Entry 91724.70",
		]
	},
	"log_1": {"pretext": "[Log Entry 91721.00] – Report from %s handler.\nCoal extraction completed successfully. The frigate has been fully loaded with all materials recovered during the last mission. Home base has been notified of mission completion. Awaiting further instructions." % App.MACHINE_NAME},
	"log_2": {"pretext": "[Log Entry 91721.15] – Report from %s handler.\n%s is no longer responding within expected parameters. Multiple subsystems have failed in sequence. Initial diagnostics suggest structural damage beyond standard field repair."  % [App.MACHINE_NAME, App.MACHINE_NAME]},
	"log_3": {"pretext": "[Log Entry 91721.92] - Report from %s handler.\n%s continues to operate intermittently despite critical faults.\nShutdown protocols are ignored or reversed. It appears to resist deactivation, maintaining minimal activity without clear directive." % [App.MACHINE_NAME, App.MACHINE_NAME]},
	"log_4": {"pretext": "[Log Entry 91722.38] – Report from %s handler.\nEngineering proposed isolating the core intelligence for extraction and transport. The procedure is viable, but requires equipment and energy reserves currently unavailable in this sector." % App.MACHINE_NAME},
	"log_5": {"pretext": "[Log Entry 91722.94] – Report from %s handler.\nDecision made to abandon %s in place. Systems remain partially active at time of departure. No further recovery actions authorized due to cost constraints." % [App.MACHINE_NAME, App.MACHINE_NAME]},
	"log_6": {"pretext": "[Log Entry 91722.94]\nIs anyone here? Am I... alone?"},
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
		"open_fail":
			if current_line == 0: return "main_menu"
		"logs":
			if current_line == 0: return "main_menu"
			elif current_line == 1: return "log_1"
			elif current_line == 2: return "log_2"
			elif current_line == 3: return "log_3"
			elif current_line == 4: return "log_4"
			elif current_line == 5: return "log_5"
			elif current_line == 6: return "log_6"
	
		

func _ready() -> void:
	render()

func create_rte() -> RichTextLabel:

	var rte = RichTextLabel.new()
	rte.fit_content = true
	rte.bbcode_enabled = true
	rte.add_theme_font_size_override("normal_font_size", 32)
	return rte
	
func render():
	for c in get_children():
		c.queue_free()
	var i = 0
	var pretext_rte = create_rte()
	pretext_rte.text = pretext
	add_child(pretext_rte)	
	for l in lines:
		var rte = create_rte()
		rte.text = "[bgcolor=%s][color=%s]%s[/color]"% [background,foreground,l] if i == current_line else l
		i += 1
		add_child(rte)
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
					
				
