class_name GridCell
extends Control


# unused for now
var grid_ui_index: Vector2i


signal cell_clicked(index: Vector2i)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			cell_clicked.emit(grid_ui_index)
