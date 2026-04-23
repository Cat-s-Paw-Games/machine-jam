extends Node
class_name GameStatusService

var combination = [7,3,9]
var lights_on = false
var pipe_touched = false
var fire_lit = false
var water_linked = false
var generator_active = false
var steam := 0.0
var max_steam := 20.0

var game_end = false
var secret_ending_unlocked = false

var cabinet_open = false
var tesseract_found = false

var card_game_uploaded = false
var flipping_cards = false
var console_logs = {
	"log_1": {"line": "Log Entry 91721.00", "pretext": "[Log Entry 91721.00] – Report from %s handler.\nCoal extraction completed successfully. The frigate has been fully loaded with all materials recovered during the last mission. Home base has been notified of mission completion. Awaiting further instructions." % App.MACHINE_NAME},
	"log_2": {"line": "Log Entry 91721.15", "pretext": "[Log Entry 91721.15] – Report from %s handler.\n%s is no longer responding within expected parameters. Multiple subsystems have failed in sequence. Initial diagnostics suggest structural damage beyond standard field repair."  % [App.MACHINE_NAME, App.MACHINE_NAME]},
	"log_3": {"line": "Log Entry 91721.92", "pretext": "[Log Entry 91721.92] - Report from %s handler.\n%s continues to operate intermittently despite critical faults. \nShutdown protocols are ignored or reversed. It appears to resist deactivation, maintaining minimal activity without clear directive." % [App.MACHINE_NAME, App.MACHINE_NAME]},
	"log_4": {"line": "Log Entry 91722.01", "pretext": "[Log Entry 91722.01] - Report from %s handler.\nAssembled a Bound Core for emergency shutdown of %s. Repurposed a spring from an old clock and the aether chambers are plentiful from the extraction operations. \nThe only other oscillation regulator is stored safely for later recovery. We're using the last syncronization module after Julian lost the last one in the toilet." % [App.MACHINE_NAME, App.MACHINE_NAME]},
	"log_5": {"line": "Log Entry 91722.38", "pretext": "[Log Entry 91722.38] – Report from %s handler.\nEngineering proposed isolating the core intelligence for extraction and transport. The procedure is viable, but requires equipment and energy reserves currently unavailable in this sector." % App.MACHINE_NAME},
	"log_6": {"line": "Log Entry 91722.94", "pretext": "[Log Entry 91722.94] – Report from %s handler.\nDecision made to abandon %s in place. Systems remain partially active at time of departure. No further recovery actions authorized due to cost constraints." % [App.MACHINE_NAME, App.MACHINE_NAME]},
	"log_7": {"line": "Log Entry 91724.70", "pretext": "[Log Entry 91722.94]\nIs anyone here? Am I... alone?"}
}

func reset():
	lights_on = false
	fire_lit = false
	water_linked = false
	generator_active = false
	steam = 0.0
	
	game_end = false
	secret_ending_unlocked = false
	
	cabinet_open = false
	tesseract_found = false
