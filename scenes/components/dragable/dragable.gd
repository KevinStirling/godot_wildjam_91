extends Node2D

var dragging : bool = false
var offset : Vector2 = Vector2(0,0)
var inventory_grid_layer : int = 4;

func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - offset

func _on_drag_handle_button_down():
	dragging = true
	offset = get_global_mouse_position() - global_position

func _on_drag_handle_button_up():
	dragging =  false


func _on_item_shape_grid_area_exited(area: Area2D) -> void:
	if area.collision_layer == inventory_grid_layer:
		print("found inventory")

func _on_item_shape_grid_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

