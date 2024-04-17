extends TerrainEnvironmentFactor

func _init():
	id = "@env_factor:main:metal"
	factor_name = "@str:main:name_env_factor_metal"
	info = "@str:main:info_env_factor_metal"

func handle_panel_env_factor(panel : PanelEnvFactor):
	super.handle_panel_env_factor(panel)
	panel.theme = preload("res://Mod/main/EnvFactor/ThemePanelMetal.tres")
	
