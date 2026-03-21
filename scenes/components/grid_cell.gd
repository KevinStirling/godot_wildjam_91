class_name GridCell
extends Control

var grid_ui_index: Vector2i
var hover_color: Color = Color(0.0, 1.0, 1.0)
var idle_color: Color = Color(1.0, 1.0, 1.0)

var is_hovered : bool :
	get():
		return is_hovered
	set(value): 
		if value == true:
			modulate = hover_color
		else:
			modulate = idle_color
		is_hovered = value
		
