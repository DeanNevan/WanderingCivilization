extends PlanetTerrain

func _init():
	self.id = "@terrain:main:snow_field"
	self.material_id = "@material:main:terrain_snow_field"
	self.env_factors_id_provide = {
		"@env_factor:main:wet" : 1,
		"@env_factor:main:cold" : 2,
		"@env_factor:main:organic" : 1,
	}
	self.env_factors_id_provide_neighbour = {
		"@env_factor:main:cold" : 1,
	}
