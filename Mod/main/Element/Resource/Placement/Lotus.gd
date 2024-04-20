extends TerrainResourcePlacement

func _init():
	super._init()
	
	id = "@element:main:resource_lotus"
	info = "@str:main:info_resource_lotus"
	element_name = "@str:main:name_resource_lotus"
	remain_percent_to_instance_count = {
		Vector2(0, 40) : 1,
		Vector2(40, 80) : 2,
		Vector2(80, 100) : 3,
	}
	scale_range = Vector2(0.2, 0.4)
	yaw_range = Vector2(0, 360)
	pitch_range = Vector2(0, 0)
	roll_range = Vector2(0, 0)
	height_offset_range = Vector2(0, 0.05)
	only_with_liquid = true
	on_liquid_surface = true
	can_with_liquid = true
	
	add_requirement(RequirementLayer.new(self))
	add_requirement(RequirementLiquid.new(self))
	
	add_requirement(RequirementEnvFactor.new(
		self,
		{
			"@env_factor:main:organic" : 6,
			"@env_factor:main:wet" : 6,
		},
		[]
	))

func new_instance(scene):
	super.new_instance(preload("res://Mod/main/Model/Lotus.tscn").instantiate())
	
