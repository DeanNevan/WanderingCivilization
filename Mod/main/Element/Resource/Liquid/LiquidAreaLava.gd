extends PlanetLiquidArea

func _init():
	id = "@liquid_area:main:lava"
	liquid_id = "@element:main:resource_liquid_lava"
	

func set_mesh(mesh):
	super.set_mesh(mesh)
	mesh_instance.set_layer_mask_value(1, false)
	mesh_instance.set_layer_mask_value(20, true)
	#mesh_instance.set_layer_mask_value(20, true)
	#var light := DirectionalLight3D.new()
	#add_child(light)
	#light.look_at(-liquid_resources[0].terrain.polygon.normal)
	#light.light_cull_mask = 524288
	#light.light_energy = 2
	#light.light_volumetric_fog_energy = 0
	#light.light_indirect_energy = 0
