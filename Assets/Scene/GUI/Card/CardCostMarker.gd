extends MarginContainer

@onready var _Icon = $VBoxContainer/Icon
@onready var _LabelCount = $VBoxContainer/LabelCount

var valid := false

var asset_id := ""
var value := 0

func init(_asset_id : String, _value : int):
	asset_id = _asset_id
	value = _value
	var instance : CivilizationAsset = R.get_asset_instance(asset_id)
	_Icon.texture = instance.icon
	_LabelCount.text = str(value)
	update_all()

func update_all():
	if valid:
		_LabelCount.modulate = Color.GREEN
	else:
		_LabelCount.modulate = Color.RED

func set_valid(_valid):
	valid = _valid
	update_all()
