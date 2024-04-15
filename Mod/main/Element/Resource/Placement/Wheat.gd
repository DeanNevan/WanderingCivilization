extends TerrainResourcePlacement

func _init():
	id = "@element:main:resource_wheat"
	info = "@str:main:info_resource_wheat"
	element_name = "@str:main:name_resource_wheat"
	remain_percent_to_instance_count = {
		Vector2(0, 30) : 1,
		Vector2(30, 50) : 2,
		Vector2(50, 70) : 3,
		Vector2(70, 100) : 4,
	}
	scale_range = Vector2(0.4, 0.6)
	yaw_range = Vector2(0, 360)
	pitch_range = Vector2(-2, 2)
	roll_range = Vector2(-2, 2)
	height_offset_range = Vector2(-0.1, -0.05)
	only_with_liquid = false
	on_liquid_surface = false
	can_with_liquid = false

func new_instance(scene):
	super.new_instance(R.new_batch_object("@batch:main:wheat"))
	
