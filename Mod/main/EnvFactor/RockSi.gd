extends TerrainEnvironmentFactor

func _init():
	id = "@env_factor:main:rock_si"
	factor_name = "@str:main:name_env_factor_rock_si"
	info = "@str:main:info_env_factor_rock_si"

func handle_panel_env_factor(panel : PanelEnvFactor):
	super.handle_panel_env_factor(panel)
	panel.theme = preload("res://Mod/main/EnvFactor/ThemePanelRockSi.tres")
	
