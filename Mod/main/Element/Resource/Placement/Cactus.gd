extends TerrainResourcePlacement

var models := [
	"res://Mod/main/Model/Cactus1.tscn",
	"res://Mod/main/Model/Cactus2.tscn",
]


var rander := RandomNumberGenerator.new()

func _init():
	super._init()
	
	id = "@element:main:resource_cactus"
	info = "@str:main:info_resource_cactus"
	element_name = "@str:main:name_resource_cactus"
	remain_percent_to_instance_count = {
		Vector2(0, 40) : 1,
		Vector2(40, 80) : 2,
		Vector2(80, 100) : 3,
	}
	scale_range = Vector2(0.2, 0.3)
	yaw_range = Vector2(0, 360)
	pitch_range = Vector2(-2, 2)
	roll_range = Vector2(-2, 2)
	height_offset_range = Vector2(-0.1, -0.05)
	only_with_liquid = false
	on_liquid_surface = false
	can_with_liquid = false
	
	add_requirement(RequirementLayer.new(self))
	add_requirement(RequirementLiquid.new(self))
	
	add_requirement(RequirementTerrain.new(
		self,
		[],
		[
			"@terrain:main:rock",
			"@terrain:main:grass_plain",
			"@terrain:main:snow_field",
			"@terrain:main:loess_land",
		]
	))
	add_requirement(RequirementEnvFactor.new(
		self,
		{
			"@env_factor:main:dry" : 5,
			"@env_factor:main:hot" : 4,
		},
		[]
	))

func new_instance(scene):
	super.new_instance(load(models[Global.rander_for_decoration.randi() % models.size()]).instantiate())
	
