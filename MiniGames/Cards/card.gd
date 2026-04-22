extends TouchScreenButton
class_name Card

signal selected(card : Card)

var is_front := false
var is_animating := false
var disabled := false

@onready var front = $Front
@onready var back = $Back

var _match_id = -1

var match_id:
	get():
		return _match_id
	set(val):
		$Front.texture = ResourceLoader.load("res://assets/images/card_game/card_%s.png" % [(val + 9 % 9) + 1])
		_match_id = val

func _ready():
	show_back()
	pressed.connect(_on_pressed)

func _on_pressed():
	if is_animating || App.game_status.flipping_cards:
		return

	await flip()
	selected.emit(self)

func flip(wait = 0):
	var original_scale = scale
	is_animating = true
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(func(): is_animating = false)
	
	# shrink (simulate turning)
	tween.tween_property(self, "scale:x", 0.0, 0.15)
	
	# switch texture at midpoint
	tween.tween_callback(func():
		is_front = !is_front
		update_visual()
	)
	
	# expand back
	tween.tween_property(self, "scale:x", original_scale.x, 0.15)
	
	await tween.finished

func update_visual():
	front.visible = is_front
	back.visible = !is_front

func show_back():
	is_front = false
	update_visual()

func match_found():
	pressed.disconnect(_on_pressed)
