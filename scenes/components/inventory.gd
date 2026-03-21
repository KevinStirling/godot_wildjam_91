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
	MouseDrag.item_picked.connect(_handle_item_picked)

func _process(_delta: float) -> void:
	if grid_ui.size() > 0:
		for row in grid_ui:
			for item in row:
				item.is_hovered = false
	if MouseDrag.dragging:
		var colls = get_grid_area_collisions(MouseDrag.current_item)
		if colls.size() > 0:
			for c in range(colls.size()):
				if colls[c].x >= dimensions.x || colls[c].y >= dimensions.y:
					return
				else:
					print(colls)
					grid_ui[colls[c].y][colls[c].x].is_hovered = true

func _handle_item_drop(item: InventoryItem):
	var colls = get_grid_area_collisions(item)
	if colls.size() > 0:
		var min_coords = colls[0]
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
		if !bad:
			if !item.rotated:
				# offset the position of the item based on the center point
				var os = Vector2(cell_size/2.0 * (item.stats.dimensions.x - 1), 0)
				# item.position = grid_ui[colls[0].y][colls[0].x].global_position + os
				item.position = grid_ui[min_coords.y][min_coords.x].global_position + os
			else:
				var os = Vector2(0, cell_size/2.0 * (item.stats.dimensions.x - 1))
				item.position = grid_ui[min_coords.y][min_coords.x].global_position + os
			place(colls, item)
	else:
		# fling 
		# apply gravity
		# set global_postion.y to + 10 or something
		# let it fall off the screen
		# when screen exited delete item
		pass

func _handle_item_picked(item: InventoryItem):
	remove(item)
	

# returns all the indexes that the item collides with on the grid
func get_grid_area_collisions(item: InventoryItem) -> Array:
	var collisions: Array = []
	# check if global_position of item is within inventory bounds
	var max_grid_bounds = global_position + Vector2(dimensions.x * cell_size, dimensions.y *cell_size)
	var min_grid_bounds = global_position
	var pos = item.global_position
	if max_grid_bounds.x > pos.x && min_grid_bounds.x < pos.x && max_grid_bounds.y > pos.y && min_grid_bounds.y < pos.y:
		var item_area = item.get_area_size()
		var offset = Vector2(0,16) if !item.rotated else Vector2(16,0)
		# adjust the position to be local based on the position in global space
		var adjusted_pos = abs(global_position - (pos + offset))
		var min_coords = Vector2i(adjusted_pos.x / cell_size, adjusted_pos.y / cell_size) 
		var max_coords = min_coords + (item_area - Vector2i.ONE)

		collisions.append(min_coords)
		collisions.append(max_coords)
		for x in range(max_coords.x - min_coords.x):
			var c = Vector2i(min_coords.x + (x + 1), min_coords.y)
			if !collisions.has(c):
				collisions.append(Vector2i(min_coords.x + (x + 1), min_coords.y))
		for y in range(max_coords.y - min_coords.y):
			var c = Vector2i(min_coords.x, min_coords.y + (y + 1))
			if !collisions.has(c):
				collisions.append(Vector2i(min_coords.x, min_coords.y + (y + 1)))
		
		for x in collisions:
			if x.x > dimensions.x || x.y > dimensions.y:
				collisions.clear()
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

func place(collisions: Array, item: InventoryItem) -> void:
	item.last_position = collisions
	for c in range(collisions.size()):
		grid_contents[collisions[c].x][collisions[c].y] = item

func remove(item: InventoryItem) -> void:
	for c in range(item.last_position.size()):
		grid_contents[item.last_position[c].x][item.last_position[c].y] = null
