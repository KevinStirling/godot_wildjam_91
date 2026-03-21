class_name InventoryItem
extends RigidBody2D

@export var stats : Resource

var cell_size: int = 32
var rotated: bool = false
var offset: Vector2 = Vector2.ZERO
var dragging: bool :
	get:
		return dragging
	set(value):
		MouseDrag.dragging = value
		dragging = value
var last_position : Array
var gravity_on: bool = false
var is_flung: bool = false

func _ready() -> void:
	%Sprite2D.texture = stats.sprite
	%Button.size = stats.dimensions * cell_size
	%Button.position = %Button.position - %Button.size / 2

func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - offset 
	if gravity_on:
		gravity_scale = 1.0
	else:
		gravity_scale = 0.0

func _physics_process(delta: float) -> void:
	if is_flung:
		apply_central_impulse(Vector2(randi_range(-180,180),-500))
		apply_force(Vector2(0, randi_range(-100, 100)),position)
		is_flung = false

func rotate_90() -> void:
	var tween = get_tree().create_tween()
	if rotated:
		tween.tween_property(%Sprite2D, "rotation_degrees", 0.0, .1)
	else:
		tween.tween_property(%Sprite2D, "rotation_degrees", 90.0 , .1)
	rotated = !rotated
	await tween.finished
	tween.kill()

func get_area_size() -> Vector2i:
	if rotated:
		return Vector2i(stats.dimensions.y, stats.dimensions.x)
	return stats.dimensions

func _on_button_button_down() -> void:
	gravity_on = false
	is_flung = false
	dragging = true
	MouseDrag.current_item = self
	offset = get_global_mouse_position() - global_position
	MouseDrag.item_picked.emit(self)

func _on_button_button_up() -> void:
	dragging = false
	MouseDrag.current_item = null
	offset = Vector2.ZERO
	MouseDrag.item_dropped.emit(self)
