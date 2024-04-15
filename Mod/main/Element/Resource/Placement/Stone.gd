extends TerrainResourcePlacement

var models := [
	"@batch:main:stone_1",
	"@batch:main:stone_2",
]

var models_snow := [
	"@batch:main:stone_snow_1",
	"@batch:main:stone_snow_2",
]

func _init():
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

func new_instance(scene):
	if terrain.id == "@terrain:main:snow_field":
		super.new_instance(R.new_batch_object(models_snow[Global.rander_for_decoration.randi() % models_snow.size()]))
	elif terrain.id == "@terrain:main:loess_land":
		super.new_instance(R.new_batch_object("@batch:main:stone_dirt"))
	else:
		super.new_instance(R.new_batch_object(models[Global.rander_for_decoration.randi() % models.size()]))
	
