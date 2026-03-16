class_name InventoryItem
extends Node2D

@export var dimensions: Vector2i
@export var texture: Texture2D

var enable_snap: bool = false
# set snap to the size of the grid cells
var snap: int = 32
var rotated: bool = false
var offset: Vector2 = Vector2.ZERO
var dragging: bool :
	get:
		return dragging
	set(value):
		MouseDrag.dragging = value
		dragging = value

func _process(_delta: float) -> void:
	if dragging:
		if enable_snap:
			var new_pos = get_global_mouse_position() - offset 
			position = Vector2(snapped(new_pos.x, snap), snapped(new_pos.y, snap))


		position = get_global_mouse_position() - offset 

func rotate_item() -> void:
	rotated = !rotated
	print(rotated)
	var tween = get_tree().create_tween()
	tween.tween_property(%Sprite2D, "rotation_degrees", 90, .1)
	await tween.finished
	tween.kill()

func get_area_size() -> Vector2i:
	if rotated:
		return Vector2i(dimensions.y, dimensions.x)
	return dimensions

func _on_button_button_down() -> void:
	dragging = true
	MouseDrag.current_item = self
	offset = get_global_mouse_position() - global_position


func _on_button_button_up() -> void:
	print("button up triggered")
	dragging = false
	MouseDrag.current_item = null
	offset = Vector2.ZERO
	# emit a signal to mouse drag that it was dropped
	# pass in the global_position where it was dropped
	MouseDrag.item_dropped.emit(self, global_position)
	# subscribe to that signal from Inventory. 

