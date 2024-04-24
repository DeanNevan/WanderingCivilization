extends TerrainBuilding

func _init():
	super._init()
	
	id = "@element:main:building_domitory"
	element_name = "@str:main:name_building_domitory"
	info = "@str:main:info_building_domitory"
	only_with_liquid = false
	on_liquid_surface = false
	can_with_liquid = false
	layer = 0
	
	building_type = BuildingType.PRODUCTION
	
	create_cost = {
		"@asset::building_material" : 4,
		"@asset::labor_force" : 2,
	}
	maintain_cost = {
		"@asset::food" : 3,
	}
	
	add_requirement(RequirementLayer.new(self))
	add_requirement(RequirementLiquid.new(self))
	
	outpost = false
	core = false
	expand_borderland = 1
	add_requirement(RequirementCivilizationTerritory.new(self))

func init_display():
	super.init_display()
	var model_scene : Node3D = preload("res://Mod/main/Model/Building/Dormitory2.tscn").instantiate()
	add_model_scene(model_scene)

func get_demo_model_scene():
	return preload("res://Mod/main/Model/Building/Dormitory2.tscn").instantiate()
