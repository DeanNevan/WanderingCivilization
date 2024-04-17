extends TerrainEnvironmentFactor

func _init():
	id = "@env_factor:main:wet"
	factor_name = "@str:main:name_env_factor_wet"
	info = "@str:main:info_env_factor_wet"

func handle_panel_env_factor(panel : PanelEnvFactor):
	super.handle_panel_env_factor(panel)
	panel.theme = preload("res://Mod/main/EnvFactor/ThemePanelWet.tres")
	
