extends PlanetTerrain

func _init():
	self.id = "@terrain:main:desert"
	self.material_id = "@material:main:desert"
	self.env_factors_id_provide = {
		"@env_factor:main:dry" : 2,
		"@env_factor:main:hot" : 2,
	}
	self.env_factors_id_provide_neighbour = {
		"@env_factor:main:dry" : 1,
		"@env_factor:main:hot" : 1,
	}
