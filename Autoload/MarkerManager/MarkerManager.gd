extends Node

var Scene_MarkerLabel3D := preload("res://Assets/Scene/MarkerLabel3D/MarkerLabel3D.tscn")
var Scene_MarkerBox3D := preload("res://Assets/Scene/MarkerBox3D/MarkerBox3D.tscn")

func new_marker_label_3d() -> MarkerLabel3D:
	return Scene_MarkerLabel3D.instantiate()

func new_marker_box_3d() -> MarkerBox3D:
	return Scene_MarkerBox3D.instantiate()
