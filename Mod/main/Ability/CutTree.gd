extends AbilityResourceHarvestSingle

func _init():
	id = "@ability:main:cut_tree"
	ability_name = "@str:main:name_ability_cut_tree"
	info = "@str:main:info_ability_cut_tree"
	icon = preload("res://Mod/main/Image/Icon/axe.png")
	exclude_self = true
	radius = 1
	valid_resource_id = [
		"@element:main:resource_forest",
		"@element:main:building_artificial_forest",
	]
	health_cost = 1
	assets_per_turn = {
		"asset::building_material" : 1,
		"asset::food" : 1,
	}
