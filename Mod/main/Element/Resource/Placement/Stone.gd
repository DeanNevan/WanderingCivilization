extends TerrainResourcePlacement

var models := [
	"res://Mod/main/Model/Stone1.tscn",
	"res://Mod/main/Model/Stone2.tscn",
]

var models_snow := [
	"res://Mod/main/Model/StoneSnow1.tscn",
	"res://Mod/main/Model/StoneSnow2.tscn",
]

func _init():
	super._init()
	
	id = "@element:main:resource_stone"
	info = "@str:main:info_resource_stone"
	element_name = "@str:main:name_resource_stone"
	remain_percent_to_instance_count = {
		Vector2(0, 20) : 1,
		Vector2(20, 40) : 2,
		Vector2(40, 60) : 3,
		Vector2(60, 80) : 4,
		Vector2(80, 100) : 5,
	}
	scale_range = Vector2(0.3, 0.5)
	yaw_range = Vector2(0, 360)
	pitch_range = Vector2(-2, 2)
	roll_range = Vector2(-2, 2)
	height_offset_range = Vector2(-0.1, -0.05)
	only_with_liquid = false
	on_liquid_surface = false
	can_with_liquid = true
	
	add_requirement(RequirementLayer.new(self))
	add_requirement(RequirementLiquid.new(self))
	
	add_requirement(RequirementEnvFactor.new(
		self,
		{
			"@env_factor:main:rock_si" : 4,
		},
		[]
	))

func new_instance(scene):
	if terrain.id == "@terrain:main:snow_field":
		super.new_instance(load(models_snow[Global.rander_for_decoration.randi() % models_snow.size()]).instantiate())
	elif terrain.id == "@terrain:main:loess_land":
		super.new_instance(preload("res://Mod/main/Model/StoneDirt.tscn").instantiate())
	else:
		super.new_instance(load(models[Global.rander_for_decoration.randi() % models.size()]).instantiate())
	
