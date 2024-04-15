extends PlanetTerrain

func _init():
	self.id = "@terrain:main:loess_land"
	self.material_id = "@material:main:loess_land"
	self.env_factors_id_provide = {
		"@env_factor:main:organic" : 3,
		"@env_factor:main:wet" : 3,
	}
	self.env_factors_id_provide_neighbour = {
		"@env_factor:main:organic" : 2,
		"@env_factor:main:wet" : 2,
	}
