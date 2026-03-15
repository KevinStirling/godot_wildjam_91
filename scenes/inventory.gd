extends Control

@export var cell_sprite : PackedScene


var cell_size : Vector2 = Vector2(32,32)
var cells : int
var prev_cells : int
var prev_rows: int
var prev_cols: int
var prev_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_avil_cell_space()
	load_grid()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_avil_cell_space():
	var rows : int = int(size.y / cell_size.y)
	print("rows: ", rows)
	print("cols: ", %GridContainer.columns)
	cells = rows * %GridContainer.columns


func load_grid():
	if prev_cells != 0 && prev_cells != cells:
		var cell_diff = cells - prev_cells
		print("cell_diff: ", cell_diff)
		var child_cells = %GridContainer.get_children()

		if child_cells.size() != 0:
			if cells < prev_cells:
				for i in range(abs(cell_diff)):
					var r = child_cells.get(child_cells.size()-1)
					%GridContainer.remove_child(r)
					r.queue_free()
					child_cells = %GridContainer.get_children()
			elif cells > prev_cells: 
				for i in range(cell_diff):
					var c = cell_sprite.instantiate()
					%GridContainer.add_child(c)
	elif cells != 0:
		for i in range(cells):
			var c = cell_sprite.instantiate()
			%GridContainer.add_child(c)
	prev_cells = cells
	prev_rows = int(size.y / cell_size.y)
	prev_cols = %GridContainer.columns
	prev_size = size

func _on_resized() -> void:
	get_avil_cell_space()
	load_grid()
