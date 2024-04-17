extends Panel
class_name PanelEnvFactor

@onready var _LabelValue = $LabelValue

var value := 0

var env_factor_instance : TerrainEnvironmentFactor

func set_env_factor_instance(_env_factor_instance):
	env_factor_instance = _env_factor_instance
	env_factor_instance.handle_panel_env_factor(self)

func set_value(_value):
	value = _value
	_LabelValue.text = str(value)
