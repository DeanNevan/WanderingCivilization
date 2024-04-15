extends TerrainResourcePlacement

var models := [
	"@batch:main:sea_grass_1",
	"@batch:main:sea_grass_2",
]


var rander := RandomNumberGenerator.new()

func _init():
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

func new_instance(scene):
	super.new_instance(R.new_batch_object(models[Global.rander_for_decoration.randi() % models.size()]))
	
