extends TouchScreenButton
class_name DraggableItem

signal dropped(item : DraggableItem)

var dragging = false
var drag_offset = Vector2()
var hitbox: Area2D
var falling = false
var fall_velocity = 0.0
var target_floor_y = 0.0  # Posizione Y target nel pavimento

@export var gravity = 800.0  # Gravità base
@export var wall_height = 400.0  # Altezza del muro
@export var floor_height = 575.0  # Altezza del pavimento
@export var max_fall_speed = 500.0  # Velocità massima di caduta
@export var screen_height = 1080.0  # Altezza dello schermo

@export var item : Item = Item.new()

func _ready():
	pressed.connect(_on_pressed)
	released.connect(_on_released)
	hitbox = find_child("Area2D") 
	if hitbox:
		hitbox.mouse_entered.connect(func(): App.mouse.hover_on(self))
		hitbox.mouse_exited.connect(func(): App.mouse.hover_out())
	set_item()

func use(item_id : String) -> bool:
	if item_id == item.material:
		item = item.transform()
		set_item()
		use_after()
		return true
	return false

func use_after():
	pass

func set_item():
	texture_normal = item.texture

func _process(_delta: float) -> void:
	drag_item()
	_process_item(_delta)

func _process_item(delta: float):
	if falling:
		apply_gravity(delta)

func apply_gravity(delta: float):
	# Calcola la gravità basata sull'altezza (per il fake 3D)
	# Più sei in alto, più veloce cadi (parallax perspective)
	var height_factor = clamp((wall_height - global_position.y) / wall_height, 0.0, 1.0)
	var current_gravity = gravity * (0.5 + height_factor)  # Da 0.5x a 1.5x gravity
	
	# Applica la gravità
	fall_velocity += current_gravity * delta
	fall_velocity = clamp(fall_velocity, 0.0, max_fall_speed)
	
	global_position.y += fall_velocity * delta
	
	# Ferma la caduta quando raggiunge il target nel pavimento
	if global_position.y >= target_floor_y:
		global_position.y = target_floor_y
		falling = false
		fall_velocity = 0.0
		dropped.emit(self)

func drag_item():
	if dragging:
		global_position = get_global_mouse_position() + drag_offset

func _on_pressed():
	dragging = true
	drag_offset = global_position - get_global_mouse_position()
	falling = false
	fall_velocity = 0.0

func _on_released():
	dragging = false
	drag_offset = Vector2()
	dropped.emit(self)
	
	# Se sono sotto il floor, rimango dove sono
	if global_position.y >= floor_height:
		falling = false
		return
	
	# Calcola il target nel pavimento basato sull'altezza attuale
	# Se droppo a Y=0 (alto) → target è screen_height (1080)
	# Se droppo a Y=574 (basso) → target è floor_height (575)
	# Mappatura inversa: più sei in alto, più scendi nel pavimento
	var normalized_drop_height = global_position.y / floor_height  # 0.0 a 1.0
	var drop_offset = 50
	var max_clamp = floor_height + texture_normal.get_size().y * scale.y
	target_floor_y = floor_height + ((1.0 - normalized_drop_height) * (screen_height - floor_height))
	target_floor_y = clamp(target_floor_y, 0, max_clamp - drop_offset)
	
	falling = true
	fall_velocity = 0.0
