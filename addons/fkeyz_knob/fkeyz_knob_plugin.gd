@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("Knob", "Control", Knob, preload("res://addons/fkeyz_knob/sprites/full_knob.png"))


func _exit_tree() -> void:
	remove_custom_type("Knob")
