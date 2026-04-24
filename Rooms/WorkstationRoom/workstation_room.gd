extends Node2D

var dropped = false

func _ready():
	$BG.queue_free()

func _on_pipe_game_pipes_connected() -> void:
	if not dropped:
		dropped = true
		var item = preload("res://Items/sync_module.tscn").instantiate()
		var start_x := 464
		var start_y := 520
		item.position = Vector2(start_x,start_y)
		add_child(item)
		var start := Vector2(start_x,start_y)
		var end_y := 775.0

		var g := 2000.0 # gravità (tweakabile)
		var t_end := sqrt((2.0 * (end_y - start.y)) / g)

		var tween := create_tween()

		tween.tween_method(
			func(t):
				var y = start.y + 0.5 * g * t * t
				item.position = Vector2(start.x, y),
			0.0,
			t_end,
			t_end
		)
		tween.tween_property(item, "position",
			Vector2(start_x + 40, 775 - 30), 0.2
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(item, "position",
			Vector2(start_x + 60, 775), 0.15
		).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
