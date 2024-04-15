extends PH_FactorBasedPlacementGenerator

func _init():
	placement_data = {
		"@element:main:resource_forest" : { # 树资源
			"priority" : 5, # 优先级，一般1-10
			"require" : {
				"@env_factor:main:organic" : 4, # 需求[有机] >= 3
				"@env_factor:main:wet" : 3, # 需求[潮湿] >= 2
			},
			"black_list_factors" : [], # 要素黑名单
			"white_list_terrains" : [], # 地块白名单,一般情况下不启用这条
			"black_list_terrains" : [ # 地块黑名单
				"@terrain:main:desert",
				"@terrain:main:rock",
			],
		},
		
		"@element:main:resource_berry_bush" : {
			"priority" : 3,
			"require" : {
				"@env_factor:main:organic" : 6,
				"@env_factor:main:wet" : 5,
			},
			"black_list_factors" : [],
			"white_list_terrains" : [],
			"black_list_terrains" : [
				"@terrain:main:desert",
				"@terrain:main:rock",
			],
		},
		
		"@element:main:resource_cactus" : {
			"priority" : 4,
			"require" : {
				"@env_factor:main:dry" : 5,
				"@env_factor:main:hot" : 4,
			},
			"black_list_factors" : [],
			"white_list_terrains" : [],
			"black_list_terrains" : [
				"@terrain:main:rock",
				"@terrain:main:grass_plain",
				"@terrain:main:snow_field",
				"@terrain:main:loess_land",
			],
		},
		
		"@element:main:resource_lotus" : {
			"priority" : 2,
			"require" : {
				"@env_factor:main:organic" : 6,
				"@env_factor:main:wet" : 6,
			},
			"black_list_factors" : [],
			"white_list_terrains" : [],
			"black_list_terrains" : [],
		},
		
		"@element:main:resource_sea_grass" : {
			"priority" : 5,
			"require" : {
				"@env_factor:main:organic" : 4,
				"@env_factor:main:wet" : 4,
			},
			"black_list_factors" : [],
			"white_list_terrains" : [],
			"black_list_terrains" : [],
		},
		
		"@element:main:resource_wheat" : {
			"priority" : 3,
			"require" : {
				"@env_factor:main:organic" : 6,
				"@env_factor:main:wet" : 3,
			},
			"black_list_factors" : [],
			"white_list_terrains" : [],
			"black_list_terrains" : [
				"@terrain:main:desert",
				"@terrain:main:rock",
			],
		},
		
		"@element:main:resource_stone" : {
			"priority" : 10,
			"require" : {
				"@env_factor:main:rock" : 4,
			},
			"black_list_factors" : [],
			"white_list_terrains" : [],
			"black_list_terrains" : [
			],
		},
	}

func handle_terrain(t : PlanetTerrain):
	super.handle_terrain(t)
