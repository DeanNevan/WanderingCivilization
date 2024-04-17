extends TerrainEnvironmentFactor

func _init():
	id = "@env_factor:main:electric"
	factor_name = "@str:main:name_env_factor_electric"
	info = "@str:main:info_env_factor_electric"

func handle_panel_env_factor(panel : PanelEnvFactor):
	super.handle_panel_env_factor(panel)
	panel.theme = preload("res://Mod/main/EnvFactor/ThemePanelElectric.tres")
	
