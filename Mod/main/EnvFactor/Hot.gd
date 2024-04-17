extends TerrainEnvironmentFactor

func _init():
	id = "@env_factor:main:hot"
	factor_name = "@str:main:name_env_factor_hot"
	info = "@str:main:info_env_factor_hot"

func handle_panel_env_factor(panel : PanelEnvFactor):
	super.handle_panel_env_factor(panel)
	panel.theme = preload("res://Mod/main/EnvFactor/ThemePanelHot.tres")
	
