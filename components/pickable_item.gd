extends DraggableItem
class_name PickableItem

func _on_pressed() -> void:
	if not App.game_status.lights_on: return
	if App.ui.inventory.add_item(item.id):
		queue_free()
		disable_hover = true
		App.mouse.hover_out()

func start_shining():
	var shader := load("res://assets/shaders/highlight.gdshader") as Shader
	if shader == null:
		push_error("Highlight shader not found")
		return null
	
	var highlight := ShaderMaterial.new()
	highlight.shader = shader
	material = highlight
func stop_shining():
	if material:
		material = null
