class_name Knob extends Sprite2D

@onready var dial: Sprite2D = %Dial

var dragging := false
var mouse_position_start: Vector2
var rotation_degrees_start: float
var dial_sensitivity := 1

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
		var distance := mouse_position_start.distance_to(mouse_position)
		if mouse_position_start.y > mouse_position.y:
			distance = -distance
		var clamped_rotation = clampf((rotation_degrees_start - distance) * dial_sensitivity, -130, 130)
		dial.rotation_degrees = clamped_rotation
