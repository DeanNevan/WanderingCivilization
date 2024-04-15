extends TerrainResourcePlacement

func _init():
	id = "@element:main:resource_berry_bush"
	info = "@str:main:info_resource_berry_bush"
	element_name = "@str:main:name_resource_berry_bush"
	remain_percent_to_instance_count = {
		Vector2(0, 40) : 1,
		Vector2(40, 80) : 2,
		Vector2(80, 100) : 3,
	}
	scale_range = Vector2(0.2, 0.4)
	yaw_range = Vector2(0, 360)
	pitch_range = Vector2(-2, 2)
	roll_range = Vector2(-2, 2)
	height_offset_range = Vector2(-0.1, 0)
	only_with_liquid = false
	on_liquid_surface = false
	can_with_liquid = false

func new_instance(scene):
	super.new_instance(R.new_batch_object("@batch:main:bush"))
