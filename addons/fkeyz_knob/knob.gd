class_name Knob extends Sprite2D

@export_range(0.1, 2.0, 0.1) var dial_sensitivity := 1.0
@export_range(-180.0, 180.0, 0.1, "degrees") var start_degrees := -130.0
@export_range(-180.0, 180.0, 0.1, "degrees") var minimum_degrees := -130.0
@export_range(-180.0, 180.0, 0.1, "degrees") var maximum_degrees := 130.0

@onready var dial: Sprite2D = %Dial

var dragging := false
var mouse_position_start: Vector2
var rotation_degrees_start: float

func _ready() -> void: dial.rotation_degrees = start_degrees

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if !event.pressed:
			dragging = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			dragging = true
			mouse_position_start = Vector2(0, event.position.y)
			rotation_degrees_start = dial.rotation_degrees
			

func _physics_process(delta: float) -> void:
	if dragging:
		var mouse_position = Vector2(0, get_global_mouse_position().y)
		var distance := mouse_position_start.distance_to(mouse_position) * dial_sensitivity
		if mouse_position_start.y > mouse_position.y:
			distance = -distance
			
		var relative_rotation = (rotation_degrees_start - distance)
		var clamped_rotation = clampf(relative_rotation, minimum_degrees, maximum_degrees)
		dial.rotation_degrees = clamped_rotation
