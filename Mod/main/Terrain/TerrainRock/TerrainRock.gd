extends PlanetTerrain

func _init():
	self.id = "@terrain:main:rock"
	self.material_id = "@material:main:terrain_rock"
	self.env_factors_id_provide = {
		"@env_factor:main:rock" : 2,
		"@env_factor:main:dry" : 1,
	}
	self.env_factors_id_provide_neighbour = {
		"@env_factor:main:rock" : 1,
	}
