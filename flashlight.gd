extends PointLight2D


func _ready() -> void:
	App.events.flashlight_on.connect(func(): visible = true)
	App.events.flashlight_off.connect(func(): visible = false)
