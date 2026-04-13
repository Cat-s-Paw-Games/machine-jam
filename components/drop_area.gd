extends Area2D

#@export var accepts : Array[PackedScene] = []
var drop_queue : Array = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func process_queue():
	for item in drop_queue:
		if item.has_method("use"):
			print("use")
		item.queue_free()

func _on_area_entered(area: Area2D):
	if area.get_parent() not in drop_queue:
		drop_queue.append(area.get_parent())
	area.get_parent().dropped = true

func _on_area_exited(area: Area2D):
	if area.get_parent() in drop_queue:
		drop_queue.erase(area.get_parent())
	area.get_parent().dropped = false
