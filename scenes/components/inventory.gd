class_name Inventory
extends Control

@export var dimensions: Vector2i = Vector2i(2,2)
@export var grid_cell: PackedScene
@export var cell_size: int = 32

@onready var grid_container = %GridContainer

# stores the node reference occupying each cell
var grid_contents: Array
# stores the node refs to grid scene nodes
var grid_ui: Array

func _ready() -> void:
	build_grid_data()
	build_grid_ui()
	MouseDrag.item_dropped.connect(_handle_item_drop)

func _handle_item_drop(item: InventoryItem):
	# check if global_position of item is within inventory bounds
	var max_grid_bounds = global_position + Vector2(dimensions.x * cell_size, dimensions.y *cell_size)
	var min_grid_bounds = global_position
	var pos = item.global_position

	# if max_grid_bounds > pos && min_grid_bounds < pos: 
	if max_grid_bounds.x > pos.x && min_grid_bounds.x < pos.x && max_grid_bounds.y > pos.y && min_grid_bounds.y < pos.y:
		# get the items dimensions
		var item_area = item.get_area_size()
		var offset = Vector2(0,16) if !item.rotated else Vector2(16,0)
		# adjust the position to be local based on the position in global space
		var adjusted_pos = abs(global_position - (pos + offset))
		# calculate the min_coords (top left corner) and the max_coords (bottom right corner) of item
		var min_coords = Vector2i(adjusted_pos.x / cell_size, adjusted_pos.y / cell_size) 
		var max_coords = min_coords + (item_area - Vector2i.ONE)
		print("min_grid_bounds", min_grid_bounds,"max_grid_bounds", max_grid_bounds, "pos", pos, "adjusted_pos", adjusted_pos, "min", min_coords, "max", max_coords)
		# get all overlapping grid coordinates
		var colls = get_grid_area_collisions(min_coords, max_coords)
		# check to see if the coords are valid drop locations
		print("colls", colls)
		print("dimensions", dimensions)
		var bad : bool = false
		for c in range(colls.size()):
			if colls[c].x >= dimensions.x || colls[c].y >= dimensions.y:
				print("break", colls[c])
				bad = true
				break
		
			if grid_contents[colls[c].x][colls[c].y] != null:
				bad = true
				break
				# yeet 
		if !bad:
			if !item.rotated:
				# offset the position of the item based on the center point
				var os = Vector2(cell_size/2.0 * (item.stats.dimensions.x - 1), 0)
				item.position = grid_ui[min_coords.y][min_coords.x].global_position + os
			else:
				var os = Vector2(0, cell_size/2.0 * (item.stats.dimensions.x - 1))
				item.position = grid_ui[min_coords.y][min_coords.x].global_position + os

		# loop through colls to put each coord in grid_contents

	# if not, fling the item away idk
	# if is, get items origin, use items dimension to determin amount of space
	# in the  grid needed
	pass

# returns all the indexes that the item collides with on the grid
func get_grid_area_collisions(lower_bound: Vector2i, upper_bound: Vector2i) -> Array:
	var collisions: Array
	collisions.append(lower_bound)
	collisions.append(upper_bound)
	for x in range(upper_bound.x - lower_bound.x):
		var c = Vector2i(lower_bound.x + (x + 1), lower_bound.y)
		if !collisions.has(c):
			collisions.append(Vector2i(lower_bound.x + (x + 1), lower_bound.y))
	for y in range(upper_bound.y - lower_bound.y):
		var c = Vector2i(lower_bound.x, lower_bound.y + (y + 1))
		if !collisions.has(c):
			collisions.append(Vector2i(lower_bound.x, lower_bound.y + (y + 1)))
	return collisions

func build_grid_data() -> void:
	var rows: Array = []
	for x in range(dimensions.x):
		var col: Array = []
		col.resize(dimensions.y)
		col.fill(null)
		rows.append(col)

	grid_contents = rows
	print(grid_contents)

func build_grid_ui() -> void:
	grid_container.columns = grid_contents.size()
	grid_container.custom_minimum_size = Vector2(cell_size * dimensions.y, cell_size * dimensions.x)
	grid_ui = array_builder(dimensions.x, dimensions.y)
	for x in range(grid_contents.size()):
		for y in range(grid_contents[x].size()):
			var cell = grid_cell.instantiate()
			grid_container.add_child(cell)	
			# rows.append(col)
			cell.grid_ui_index = Vector2i(x,y)
			grid_ui[x][y] = cell
	
	print(grid_ui)

func array_builder(rows: int, cols: int) -> Array:
	var r: Array = []
	for x in range(rows):
		var col: Array = []
		col.resize(cols)
		col.fill(null)
		r.append(col)

	return r

func can_place() -> void:
	pass

func place() -> void:
	# iterate through returns array from get_grid_area_collisions
	# add them each to the grid_contents at the same index
	pass

func remove() -> void:
	pass


# wont work becuase the control cant detect the mouse when theres a node2d in the way
# func _on_mouse_entered() -> void:
# 	if MouseDrag.dragging:
# 		MouseDrag.current_item.enable_snap = true
# 		# set movement of item to snapped
#
#
# func _on_mouse_exited() -> void:
# 	if MouseDrag.dragging:
# 		MouseDrag.current_item.enable_snap = false

#
# func _on_focus_entered() -> void:
# 	print("focued")
