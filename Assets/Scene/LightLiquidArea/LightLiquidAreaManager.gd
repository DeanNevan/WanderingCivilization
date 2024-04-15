extends Node3D
class_name LightLiquidAreaManager

var Scene_LightLiquidArea := preload("res://Assets/Scene/LightLiquidArea/LightLiquidArea.tscn")

func init(r : float):
	for i in get_children():
		i.position *= r
	
