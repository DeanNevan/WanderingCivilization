@tool
extends Container
class_name CircularContainer

@export var start_deg : float = -90.0:
	set(_start_deg):
		start_deg = _start_deg
		_on_sort_children()
@export var skip_first := false:
	set(_skip_first):
		skip_first = _skip_first
		_on_sort_children()
@export var expand := true:
	set(_expand):
		expand = _expand
		_on_sort_children()
@export var deg_step := 30.0:
	set(_deg_step):
		deg_step = _deg_step
		_on_sort_children()

func _on_sort_children():
	var s : int = get_child_count()
	if skip_first:
		s += 1
	
	var _deg_step : float = deg_step
	if expand:
		_deg_step = 360.0 / s
	var center : Vector2 = global_position + size / 2.0
	var radius : float = size.x / 2.0
	for i in s:
		var deg : float = start_deg + _deg_step * (i if !skip_first else (i + 1))
		get_child(i).global_position = center + Vector2(radius, 0).rotated(deg_to_rad(deg))
		get_child(i).global_position -= get_child(i).size / 2.0
	pass # Replace with function body.
