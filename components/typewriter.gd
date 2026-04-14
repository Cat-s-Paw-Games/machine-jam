extends RichTextLabel
class_name TypewriterLabel

@export var chararacters_for_second: float = 1.0
@onready var character_count = get_total_character_count()

func _ready() -> void:
	var animation_time = character_count / chararacters_for_second
	var anim : Animation = $AnimationPlayer.get_animation("write")
	var track_index = anim.add_track(Animation.TYPE_VALUE)
	anim.length = animation_time
	anim.track_set_path(track_index, ":visible_characters")
	anim.track_insert_key(track_index, 0.0, 0)
	anim.track_insert_key(track_index, animation_time, character_count)
	$AnimationPlayer.play("write")
	
func finish():
	$AnimationPlayer.stop()
	visible_characters = character_count
