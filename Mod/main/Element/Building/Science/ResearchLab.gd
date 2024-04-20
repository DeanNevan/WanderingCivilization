extends TerrainBuilding

func _init():
	super._init()
	
	id = "@element:main:building_research_lab"
	info = "@str:main:info_building_research_lab"
	element_name = "@str:main:name_building_research_lab"
	only_with_liquid = false
	on_liquid_surface = false
	can_with_liquid = false
	layer = 0
	
	building_type = BuildingType.PRODUCTION
	
	add_requirement(RequirementLayer.new(self))
	add_requirement(RequirementLiquid.new(self))

func init_display():
	super.init_display()
	var model_scene : Node3D = preload("res://Mod/main/Model/Building/ResearchLab.tscn").instantiate()
	add_model_scene(model_scene)
