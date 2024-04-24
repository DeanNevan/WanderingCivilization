extends CardBuilding

func _init():
	id = "@card:main:building_watchtower"
	card_name = "@str:main:name_building_watchtower"
	info = "@str:main:info_building_watchtower"
	element_script = preload("res://Mod/main/Element/Building/Science/Watchtower.gd")
	icon = preload("res://Mod/main/Image/Science/Building/MediavalTower.png")

