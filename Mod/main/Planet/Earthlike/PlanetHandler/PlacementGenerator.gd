extends PH_FactorBasedPlacementGenerator

func _init():
	placement_data = {
		"@element:main:resource_forest" : 5,
		
		"@element:main:resource_berry_bush" : 3,
		
		"@element:main:resource_cactus" : 4,
		
		"@element:main:resource_lotus" : 2,
		
		"@element:main:resource_sea_grass" : 5,
		
		"@element:main:resource_wheat" : 3,
		
		"@element:main:resource_stone" : 10,
	}

func handle_terrain(t : PlanetTerrain):
	super.handle_terrain(t)
