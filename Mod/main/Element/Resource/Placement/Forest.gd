extends TerrainResourcePlacement

func _init():
	super._init()
	
	id = "@element:main:resource_forest"
	info = "@str:main:info_resource_forest"
	element_name = "@str:main:name_resource_forest"
	
	remain_percent_to_instance_count = {
		Vector2(0, 20) : 1,
		Vector2(20, 40) : 2,
		Vector2(40, 60) : 3,
		Vector2(60, 80) : 4,
		Vector2(80, 100) : 5,
	}
	scale_range = Vector2(0.5, 1.0)
	yaw_range = Vector2(0, 360)
	pitch_range = Vector2(-5, 5)
	roll_range = Vector2(-5, 5)
	height_offset_range = Vector2(-0.1, -0.05)
	on_liquid_surface = false
	can_with_liquid = false
	only_with_liquid = false
	
	add_requirement(RequirementLayer.new(self))
	add_requirement(RequirementLiquid.new(self))
	
	add_requirement(RequirementTerrain.new(
		self,
		[],
		[
			"@terrain:main:desert",
			"@terrain:main:rock",
		]
	))
	add_requirement(RequirementEnvFactor.new(
		self,
		{
			"@env_factor:main:organic" : 4, # 需求[有机] >= 3
			"@env_factor:main:wet" : 3, # 需求[潮湿] >= 2
		},
		[]
	))

func new_instance(scene):
	if terrain.id == "@terrain:main:snow_field":
		super.new_instance(preload("res://Mod/main/Model/TreeSnow.tscn").instantiate())
	else:
		super.new_instance(preload("res://Mod/main/Model/Tree.tscn").instantiate())
