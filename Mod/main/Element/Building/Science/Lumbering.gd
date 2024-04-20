extends TerrainBuilding

func _init():
	super._init()
	
	id = "@element:main:building_lumbering"
	info = "@str:main:info_building_lumbering"
	element_name = "@str:main:name_building_lumbering"
	only_with_liquid = false
	on_liquid_surface = false
	can_with_liquid = false
	layer = 0
	
	create_cost = {
		"@asset::building_material" : 2,
		"@asset::labor_force" : 4,
	}
	maintain_cost = {
		
	}
	
	building_type = BuildingType.PRODUCTION
	
	add_requirement(RequirementLayer.new(self))
	add_requirement(RequirementLiquid.new(self))

func init_display():
	super.init_display()
	var model_scene : Node3D = preload("res://Mod/main/Model/Building/Lumbering.tscn").instantiate()
	add_model_scene(model_scene)

func get_demo_model_scene():
	return preload("res://Mod/main/Model/Building/Lumbering.tscn").instantiate()