extends RichTextLabel
class_name TypewriterLabel

signal animation_finished()

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
	$AnimationPlayer.animation_finished.connect(func():
		animation_finished.emit()
	)
	
func finish():
	$AnimationPlayer.stop()
	animation_finished.emit()
	visible_characters = character_count
