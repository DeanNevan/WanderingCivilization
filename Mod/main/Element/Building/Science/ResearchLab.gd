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
	
	create_cost = {
		"@asset::building_material" : 6,
		"@asset::labor_force" : 3,
	}
	maintain_cost = {
		"@asset::labor_force" : 1,
	}
	
	add_requirement(RequirementLayer.new(self))
	add_requirement(RequirementLiquid.new(self))
	
	outpost = false
	core = false
	expand_borderland = 1
	add_requirement(RequirementCivilizationTerritory.new(self))

func init_display():
	super.init_display()
	var model_scene : Node3D = preload("res://Mod/main/Model/Building/ResearchLab.tscn").instantiate()
	add_model_scene(model_scene)

func get_demo_model_scene():
	return preload("res://Mod/main/Model/Building/ResearchLab.tscn").instantiate()
