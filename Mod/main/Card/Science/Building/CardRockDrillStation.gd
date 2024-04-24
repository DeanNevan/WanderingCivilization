extends CardBuilding

func _init():
	id = "@card:main:building_rock_drill_station"
	card_name = "@str:main:name_building_rock_drill_station"
	info = "@str:main:info_building_rock_drill_station"
	element_script = preload("res://Mod/main/Element/Building/Science/RockDrillStation.gd")
	icon = preload("res://Mod/main/Image/Science/Building/RockDrillStation.png")

