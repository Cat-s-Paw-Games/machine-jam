extends VBoxContainer

var screens = {
	"main_menu":  {
		"pretext" :"Welcome to %s CONTROL PANEL." % App.MACHINE_NAME
	},
	"open_fail":  {
		"pretext" :"Bound Core missing. Emergency procedure unavailable" 
	},
	"open_success":  {
		"pretext" :"Emergency procedure initiatied" 
	},
	"logs": {
		"pretext" :"System logs"
	}
}
var current_screen = "main_menu"

var pretext:
	get():
		return screens[current_screen].get("pretext","")


func _ready() -> void:
	render()
	load_data()

func load_data():
	for log_id in App.game_status.console_logs:
		screens[log_id] = App.game_status.console_logs[log_id]

func create_rte() -> RichTextLabel:
	var rte = RichTextLabel.new()
	rte.fit_content = true
	rte.bbcode_enabled = true
	rte.add_theme_font_size_override("normal_font_size", 32)
	return rte
	
func render():
	for c in get_children():
		c.queue_free()
	
	var pretext_rte = create_rte()
	pretext_rte.text = pretext
	add_child(pretext_rte)
