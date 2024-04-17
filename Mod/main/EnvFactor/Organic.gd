extends TerrainEnvironmentFactor

func _init():
	id = "@env_factor:main:organic"
	factor_name = "@str:main:name_env_factor_organic"
	info = "@str:main:info_env_factor_organic"

func handle_panel_env_factor(panel : PanelEnvFactor):
	super.handle_panel_env_factor(panel)
	panel.theme = preload("res://Mod/main/EnvFactor/ThemePanelOrganic.tres")
	
