extends RichTextLabel
class_name TypewriterLabel

signal animation_finished()

@export var characters_for_second: float = 1.0
@export var beep_talk: bool = true
@onready var character_count = get_total_character_count()

var last_visible_characters: int = 0
var tween: Tween
var pause_positions: Array[Dictionary] = []  # {pos: int, duration: float}

func _ready() -> void:
	recalc_animation()

func recalc_animation():
	last_visible_characters = 0
	visible_characters = 0
	pause_positions = []
	var regex = RegEx.new()
	regex.compile(r"\[pause(?:=(\d+\.?\d*))?\]")
	
	var text_content = get_parsed_text()
	if text_content.length() <= 0:
		return
	
	while true:
		var matched = regex.search(text_content)
		if matched == null:
			break
			
		var pause_start = matched.get_start()
		var pause_duration = 1.0
		if matched.strings.size() > 1 and matched.strings[1]:
			pause_duration = float(matched.strings[1])
		pause_positions.append({"pos": pause_start, "duration": pause_duration})
		text_content = regex.sub(text_content, "")
	
	text = regex.sub(text,"",true)
	character_count = get_total_character_count()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	
	for i in range(character_count):
		for pause in pause_positions:
			if i == pause["pos"]:
				tween.tween_interval(pause["duration"])
		tween.tween_property(self, "visible_characters", i + 1, 1.0 / characters_for_second)
	
	tween.finished.connect(func():
		animation_finished.emit()
	)
	

func _process(_delta: float) -> void:
	if visible_characters > last_visible_characters:
		var pitch = 6
		if text[visible_characters - 1] in ["a","e","i","o","u","y"]:
			pitch = 8.0
		if beep_talk: App.audio.play("sfx", "res://assets/music/sfx/text_beep.wav",{"pitch": pitch, "volume_db":-10.0})
		last_visible_characters = visible_characters
	
func finish():
	if tween:
		tween.kill()
	animation_finished.emit()
	visible_characters = character_count
