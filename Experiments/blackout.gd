extends CanvasLayer

var pano_width = 7680

@export var light_world_x := 2500.0
@export var light_screen_y := 0.2	


func _on_cucucc_experiments_offset_changed(offset: int) -> void:
	var viewport_width = App.viewport_size.x
	var bg_offset = offset

	var delta = wrapf(light_world_x - bg_offset + pano_width * 0.5, 0.0, pano_width) - pano_width * 0.5

	var screen_x = 0.5 + delta / viewport_width

	$ColorRect.material.set_shader_parameter("center", Vector2(screen_x, light_screen_y))


func light_up():
	queue_free()
