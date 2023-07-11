## A simple knob UI node that lets you rotate a knob by dragging it up and down.
##
## In order to use this script, please use knob.tscn. Using the knob.gd script alone will not work.[br][br]
## In case you want to change the knobs' default art, go inside the knob.tscn and change the sprites of the [code]Sprite2D[/code] nodes.
## You might also need to resize them and scale them differently, and update the main "Knob" [code]Control[/code] nodes' [code]Custom Minimum Size[/code] in order to be able to use it correctly in conjunction with other UI elements in your scene.
class_name Knob extends Control



## How fast the dial moves with the mouse movement.
@export_range(0.1, 2.0, 0.1) var dial_sensitivity := 1.0
## The rotation degrees the dial will start at.
@export_range(-180.0, 180.0, 0.1, "degrees") var start_degrees := -130.0
## The minimum rotation degrees the dial can be at.
@export_range(-180.0, 180.0, 0.1, "degrees") var minimum_degrees := -130.0
## The maxiumum rotation degrees the dial can be at.
@export_range(-180.0, 180.0, 0.1, "degrees") var maximum_degrees := 130.0

@onready var _dial: Sprite2D = %Dial

var _dragging := false
var _mouse_position_start: Vector2
var _rotation_degrees_start: float

func _ready() -> void: _dial.rotation_degrees = start_degrees

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if !event.pressed:
			_dragging = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			_dragging = true
			_mouse_position_start = Vector2(0, event.position.y)
			_rotation_degrees_start = _dial.rotation_degrees
			

func _physics_process(delta: float) -> void:
	if _dragging:
		var mouse_position = Vector2(0, get_global_mouse_position().y)
		var distance := _mouse_position_start.distance_to(mouse_position) * dial_sensitivity
		if _mouse_position_start.y > mouse_position.y:
			distance = -distance
			
		var relative_rotation = (_rotation_degrees_start - distance)
		var clamped_rotation = clampf(relative_rotation, minimum_degrees, maximum_degrees)
		_dial.rotation_degrees = clamped_rotation
