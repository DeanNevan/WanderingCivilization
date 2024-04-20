extends MarginContainer

@export var asset_id : String

@onready var _Icon = $HBoxContainer/Icon
@onready var _Label = $HBoxContainer/Label

var civilization : Civilization
var asset : CivilizationAsset

func _ready():
	update_all()

func set_civilization(_civilization):
	civilization = _civilization

func update_all():
	if is_instance_valid(asset):
		_Label.text = str(asset.value)
	else:
		_Label.text = "0"

func init():
	asset = civilization.asset_manager.assets[asset_id]
	if !is_instance_valid(asset):
		civilization.asset_manager.add_asset(asset_id, 0)
	asset = civilization.asset_manager.assets[asset_id]
	_Icon.texture = asset.icon
	asset.changed.connect(_on_asset_changed)
	update_all()

func _on_asset_changed(_asset):
	update_all()
