extends CivilizationAsset
class_name CivilizationAssetFood
func _init():
	id = "@asset::food"
	asset_name = "@str::name_food"
	info = "@str::info_food"
	icon = preload("res://Assets/Icon/apple.png")
