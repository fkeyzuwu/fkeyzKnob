## A simple knob UI node that lets you rotate a knob by dragging it up and down, or by scrolling the mouse while while hovering the cursor over it.
##
## In order to use this script, please use knob.tscn. Using the knob.gd script alone will not work.[br][br]
## In case you want to change the knobs' default art, go inside the knob.tscn and change the sprites of the [code]Sprite2D[/code] nodes.
## You might also need to resize them and scale them differently, aswell as update the [code]Custom Minimum Size[/code] on the "Knob" [code]Control[/code] node in order to be able to use it correctly in conjunction with other UI elements in your scene.
@icon("res://addons/fkeyz_knob/sprites/full_knob_icon.png")
@tool
class_name Knob extends Control

## How fast the dial moves with the mouse movement.
@export_range(0.1, 2.0, 0.1) var dial_sensitivity := 1.0
## The rotation degrees the dial will start at.
@export_range(-180.0, 180.0, 0.1, "degrees") var start_degrees := -130.0:
	set(value):
		if not is_inside_tree(): await ready
		start_degrees = clampf(value, minimum_degrees, maximum_degrees)
		_dial.rotation_degrees = start_degrees
## The minimum rotation degrees the dial can be at.
@export_range(-180.0, 180.0, 0.1, "degrees") var minimum_degrees := -130.0:
	set(value):
		if not is_inside_tree(): await ready
		minimum_degrees = clampf(value, -180.0, maximum_degrees)
## The maxiumum rotation degrees the dial can be at.
@export_range(-180.0, 180.0, 0.1, "degrees") var maximum_degrees := 130.0:
	set(value):
		if not is_inside_tree(): await ready
		maximum_degrees = clampf(value, minimum_degrees, 180.0)
## The change in degrees per mouse wheel event. Negative values will make it work in reverse. Can be set to zero to prevent the effect.
@export_range(-360, 360, 0.1, "degrees") var wheel_increment := 10

@onready var _dial: Sprite2D = %Dial

var _dragging := false
var _last_mouse_angle := 0.0
var _mouse_position_start: Vector2
var _rotation_degrees_start: float

## Emitted whenever the dial is rotated, passing in the degrees it is currently set at, as well as a value from 0 to 1 representing the current degrees compared to the minimum and maximum degrees.
signal dial_rotated(degrees: float, value: float)

func _ready() -> void: _dial.rotation_degrees = start_degrees

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed:
			_dragging = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_dragging = true
			_mouse_position_start = Vector2(0, event.position.y)
			_rotation_degrees_start = _dial.rotation_degrees

			var center = get_global_rect().get_center()
			var dir = event.global_position - center
			_last_mouse_angle = atan2(dir.y, dir.x)

		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_released():
			var relative_rotation = _dial.rotation_degrees + wheel_increment
			var clamped_rotation = clampf(relative_rotation, minimum_degrees, maximum_degrees)
			_dial.rotation_degrees = clamped_rotation
			dial_rotated.emit(_dial.rotation_degrees, _calculate_value(_dial.rotation_degrees))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_released():
			var relative_rotation = _dial.rotation_degrees - wheel_increment
			var clamped_rotation = clampf(relative_rotation, minimum_degrees, maximum_degrees)
			_dial.rotation_degrees = clamped_rotation
			dial_rotated.emit(_dial.rotation_degrees, _calculate_value(_dial.rotation_degrees))

func _physics_process(delta: float) -> void:
	if not _dragging:
		return

	var center = get_global_rect().get_center()
	var mouse_dir = get_global_mouse_position() - center
	var current_angle = atan2(mouse_dir.y, mouse_dir.x)

	var angle_delta = rad_to_deg(current_angle - _last_mouse_angle)

	# Prevent sudden jumps when crossing -PI / PI
	if angle_delta > 180.0:
		angle_delta -= 360.0
	elif angle_delta < -180.0:
		angle_delta += 360.0

	_last_mouse_angle = current_angle

	var relative_rotation = _dial.rotation_degrees + angle_delta * dial_sensitivity
	var clamped_rotation = clampf(relative_rotation, minimum_degrees, maximum_degrees)

	_dial.rotation_degrees = clamped_rotation
	dial_rotated.emit(_dial.rotation_degrees, _calculate_value(_dial.rotation_degrees))

func _calculate_value(degree: float):
	var adjustedAngle = degree - minimum_degrees
	var value: float = adjustedAngle / (maximum_degrees - minimum_degrees)
	return value
