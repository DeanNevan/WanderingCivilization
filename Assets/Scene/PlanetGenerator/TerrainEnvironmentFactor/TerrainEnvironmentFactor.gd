extends Node
class_name TerrainEnvironmentFactor

var id := "@env_factor::default"
var info := "@str::default_factor_info"
var factor_name := "@str::default_factor_name"

#@export var Scene_PanelEnvFactor := preload("res://Assets/Scene/GUI/PanelEnvFactor/PanelEnvFactor.tscn")

func handle_panel_env_factor(panel : PanelEnvFactor):
	pass
