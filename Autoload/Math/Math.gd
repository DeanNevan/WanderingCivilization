extends Node

func get_normal_via_triangle(p1 : Vector3, p2 : Vector3, p3 : Vector3):
	return (p1 - p2).cross(p3 - p1)
