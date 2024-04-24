extends CardBuilding

func _init():
	id = "@card:main:building_research_lab"
	card_name = "@str:main:name_building_research_lab"
	info = "@str:main:info_building_research_lab"
	element_script = preload("res://Mod/main/Element/Building/Science/ResearchLab.gd")
	icon = preload("res://Mod/main/Image/Science/Building/ResearchLab.png")

