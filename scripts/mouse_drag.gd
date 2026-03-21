extends Node

var current_item: InventoryItem
var dragging: bool = false

signal item_dropped(item: InventoryItem)
signal item_picked(item: InventoryItem)

func _input(event: InputEvent) -> void:
	if dragging:
		if event is InputEventMouseButton && event.is_pressed():
			if event.button_index == MOUSE_BUTTON_RIGHT:
				current_item.rotate_90()
