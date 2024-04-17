extends TerrainEnvironmentFactor

func _init():
	id = "@env_factor:main:acid"
	factor_name = "@str:main:name_env_factor_acid"
	info = "@str:main:info_env_factor_acid"

func handle_panel_env_factor(panel : PanelEnvFactor):
	super.handle_panel_env_factor(panel)
	panel.theme = preload("res://Mod/main/EnvFactor/ThemePanelAcid.tres")
	
