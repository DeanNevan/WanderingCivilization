extends PlanetTerrain

func _init():
	self.id = "@terrain:main:grass_plain"
	self.material_id = "@material:main:grass_plain"
	self.env_factors_id_provide = {
		"@env_factor:main:organic" : 2,
		"@env_factor:main:wet" : 1,
	}
	self.env_factors_id_provide_neighbour = {
		"@env_factor:main:organic" : 1,
		"@env_factor:main:wet" : 1,
	}
