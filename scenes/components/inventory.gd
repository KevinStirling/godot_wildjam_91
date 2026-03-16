class_name Inventory
extends Control

@export var dimensions: Vector2i = Vector2i(2,2)
@export var grid_cell: PackedScene
@export var cell_size: int = 32

# stores the node reference occupying each cell
var grid_contents: Array

# stores the node refs to grid scene nodes
var grid_ui: Array

@onready var grid_container = %GridContainer

func _ready() -> void:
	build_grid_data()
	build_grid_ui()
	MouseDrag.item_dropped.connect(_handle_item_drop)

func _handle_item_drop(item: InventoryItem, pos: Vector2):
	# check if global_position of item is within inventory bounds
	var grid_bounds = global_position + Vector2(dimensions.x * cell_size, dimensions.y *cell_size)
	if grid_bounds.x > pos.x && global_position.x < pos.x && grid_bounds.y > pos.y && global_position.y < pos.y:
		var item_area = item.get_area_size()
		print("sucess")
		var min_coords = Vector2i(pos.y / cell_size, pos.x / cell_size)
		# need to account for item.dimensions to make sure it stays on the grid
		var max_coords = min_coords + (item_area - Vector2i.ONE)


		print(min_coords, max_coords)
		

		# replace the zeros with something that gets the right val
		if min_coords.x >= 0 && max_coords.x <= (dimensions.x - 1) && min_coords.y >= 0 && max_coords.y <= (dimensions.y - 1):
			print("in da grid")
			var colls = get_grid_area_collisions(min_coords, max_coords)
			print(colls)
			

			item.position = grid_ui[min_coords.x][min_coords.y].position
		# check if there is an item in and of the dimensions
		
		



	
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
		print(x)
		collisions.append(Vector2i(lower_bound.x + (x + 1), lower_bound.y))
	for y in range(upper_bound.y - lower_bound.y):
		print("y")
		collisions.append(Vector2i(lower_bound.x, lower_bound.y + (y + 1)))
	return collisions

# func _gui_input(event: InputEvent) -> void:
# 	if event is InputEventMouseButton && event.is_released():
# 		if event.button_index == MOUSE_BUTTON_LEFT:
			# probably should check if its within the bounds of the grid firts and throw it	
			# away if not.. with all this click and dragging
			# position coords are flipped compared to grid_ui storage process, so calc the 
			# event coords with x and y flipped before getting node ref from grid_ui
			# var coords = Vector2i(event.position.y / cell_size, event.position.x / cell_size)
			# print(grid_ui[coords.x][coords.y])
			# If holding an item, get the item size and use it as an offset to determine the
			# grid_ui under the top left corner

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
	pass

func remove() -> void:
	pass


# wont work becuase the control cant detect the mouse when theres a node2d in the way
func _on_mouse_entered() -> void:
	if MouseDrag.dragging:
		MouseDrag.current_item.enable_snap = true
		# set movement of item to snapped


func _on_mouse_exited() -> void:
	if MouseDrag.dragging:
		MouseDrag.current_item.enable_snap = false
