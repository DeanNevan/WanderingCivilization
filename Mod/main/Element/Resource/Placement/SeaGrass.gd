extends TerrainResourcePlacement

var models := [
	"res://Mod/main/Model/SeaGrass1.tscn",
	"res://Mod/main/Model/SeaGrass2.tscn",
]


var rander := RandomNumberGenerator.new()

func _init():
	super._init()
	
	id = "@element:main:resource_sea_grass"
	info = "@str:main:info_resource_sea_grass"
	element_name = "@str:main:name_resource_sea_grass"
	remain_percent_to_instance_count = {
		Vector2(0, 40) : 1,
		Vector2(40, 80) : 2,
		Vector2(80, 100) : 3,
	}
	scale_range = Vector2(0.3, 0.5)
	yaw_range = Vector2(0, 360)
	pitch_range = Vector2(-2, 2)
	roll_range = Vector2(-2, 2)
	height_offset_range = Vector2(-0.1, -0.05)
	only_with_liquid = true
	on_liquid_surface = false
	can_with_liquid = true
	
	add_requirement(RequirementLayer.new(self))
	add_requirement(RequirementLiquid.new(self))
	
	add_requirement(RequirementEnvFactor.new(
		self,
		{
			"@env_factor:main:organic" : 4,
			"@env_factor:main:wet" : 4,
		},
		[]
	))

func new_instance(scene):
	super.new_instance(load(models[Global.rander_for_decoration.randi() % models.size()]).instantiate())
	
