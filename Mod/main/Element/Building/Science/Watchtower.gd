extends TerrainBuilding

func _init():
	super._init()
	
	id = "@element:main:building_watch_tower"
	info = "@str:main:info_building_watch_tower"
	element_name = "@str:main:name_building_watch_tower"
	only_with_liquid = false
	on_liquid_surface = false
	can_with_liquid = false
	layer = 0
	
	building_type = BuildingType.FUNCTION
	
	add_requirement(RequirementLayer.new(self))
	add_requirement(RequirementLiquid.new(self))

func init_display():
	super.init_display()
	var model_scene : Node3D = preload("res://Mod/main/Model/Building/MedievalTower.tscn").instantiate()
	add_model_scene(model_scene)
