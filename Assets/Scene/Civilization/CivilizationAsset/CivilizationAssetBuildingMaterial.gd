extends CivilizationAsset
class_name CivilizationAssetBuildingMaterial

func _init():
	id = "@asset::building_material"
	asset_name = "@str::name_building_material"
	info = "@str::info_building_material"
	icon = preload("res://Assets/Icon/brick.png")
