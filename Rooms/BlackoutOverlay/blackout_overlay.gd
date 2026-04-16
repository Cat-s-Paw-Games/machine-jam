extends CanvasLayer

var pano_width = 7680

@export var light_world_x := 412.0
@export var light_screen_y := 0.35

func _ready() -> void:
	get_tree().paused = true
	App.events.switch_lights_on.connect(func(): light_up())

func light_up():
	get_tree().paused = false
	queue_free()


func _on_main_offset_changed(offset: int) -> void:
	var viewport_width = 1920.0
	var bg_offset = offset

	var delta = wrapf(light_world_x - bg_offset + pano_width * 0.5, 0.0, pano_width) - pano_width * 0.5

	var screen_x = 0.5 + delta / viewport_width

	$ColorRect.material.set_shader_parameter("center", Vector2(screen_x, light_screen_y))
