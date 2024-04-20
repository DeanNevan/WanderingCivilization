extends TerrainBuilding

func _init():
	super._init()
	
	id = "@element:main:building_ship_lander"
	info = "@str:main:info_building_ship_lander"
	element_name = "@str:main:name_building_ship_lander"
	only_with_liquid = false
	on_liquid_surface = false
	can_with_liquid = false
	layer = 0
	
	building_type = BuildingType.CORE
	
	add_requirement(RequirementLayer.new(self))
	add_requirement(RequirementLiquid.new(self))

func init_display():
	super.init_display()
	var model_scene : Node3D = preload("res://Mod/main/Model/Building/CoreStation.tscn").instantiate()
	add_model_scene(model_scene)
