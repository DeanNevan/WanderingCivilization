extends TerrainResourcePlacement

func _init():
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

func new_instance(scene):
	super.new_instance(R.new_batch_object("@batch:main:lotus"))
	
