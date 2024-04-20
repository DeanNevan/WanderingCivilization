extends CivilizationAsset
class_name CivilizationAssetResearchPoint

func _init():
	id = "@asset::research_point"
	asset_name = "@str::name_research_point"
	info = "@str::info_research_point"
	icon = preload("res://Assets/Icon/science.png")
