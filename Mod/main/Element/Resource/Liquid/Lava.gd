extends TerrainResourceLiquid

func _init():
	super._init()
	
	id = "@element:main:resource_liquid_lava"
	info = "@str:main:info_resource_liquid_lava"
	element_name = "@str:main:name_resource_liquid_lava"
	env_factors_id_modification = {
		"@env_factor:main:hot" : 3,
		"@env_factor:main:dry" : 3,
		"@env_factor:main:wet" : -3,
		"@env_factor:main:cold" : -3,
	}
	env_factors_id_modification_neighbour = {
		"@env_factor:main:hot" : 2,
		"@env_factor:main:dry" : 2,
		"@env_factor:main:wet" : -2,
		"@env_factor:main:cold" : -2,
	}
	material_id = "@material:main:liquid_lava"
