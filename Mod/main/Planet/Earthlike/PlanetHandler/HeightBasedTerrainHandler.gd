extends PH_HeightBasedTerrainModifier

func _init():
	super._init()
	terrains_height_level_priorities = {
		"@terrain:main:grass_plain" : {
			10 : [0],
			8 : [-1, 1],
			6 : [-2, 2],
		},
		"@terrain:main:rock" : {
			10 : [-8, -7, -6, -5, -4, 4, 5, 6, 7, 8],
			7 : [-3, 3],
			4 : [-2, 2],
		},
		"@terrain:main:desert" : {
			6 : [0],
			3 : [-1, 1],
		},
		"@terrain:main:snow_field" : {
			10 : [8],
			9 : [7],
			8 : [6],
		},
		"@terrain:main:loess_land" : {
			2 : [-8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8],
		},
	}
	pass
