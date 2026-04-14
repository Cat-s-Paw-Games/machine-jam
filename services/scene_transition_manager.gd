extends CanvasLayer

@onready var rect: ColorRect = $ColorRect

var _is_busy := false

func _ready() -> void:
	rect.visible = true
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_set_progress(0.0)
	_set_invert(false)

func _set_progress(value: float) -> void:
	var mat := rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("progress", value)

func _set_invert(value: bool) -> void:
	var mat := rect.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("invert", value)

func change_scene_with_wipe(path: String, duration: float = 0.6) -> void:
	if _is_busy:
		return

	_is_busy = true

	_set_invert(false)
	var tween_out := create_tween()
	tween_out.tween_method(_set_progress, 0.0, 1.0, duration)
	await tween_out.finished

	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	
	var tween_in := create_tween()
	tween_in.tween_method(_set_progress, 1.0, 0.0, duration)
	await tween_in.finished


	_is_busy = false
