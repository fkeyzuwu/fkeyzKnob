@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("Knob", "Sprite2D", Knob, preload("res://icon.svg"))


func _exit_tree() -> void:
	remove_custom_type("Knob")