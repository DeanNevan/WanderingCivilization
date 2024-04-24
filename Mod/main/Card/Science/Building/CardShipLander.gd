extends CardBuilding

func _init():
	id = "@card:main:building_ship_lander"
	card_name = "@str:main:name_building_ship_lander"
	info = "@str:main:info_building_ship_lander"
	element_script = preload("res://Mod/main/Element/Building/Science/ShipLander.gd")
	icon = preload("res://Mod/main/Image/Science/Building/ShipLander.png")

