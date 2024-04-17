extends Planet

func _init():
	self.id = "@planet:main:earthlike"

func _ready():
	add_handler(R.get_planet_handler("@planet_handler::copy_based_initial").new())
	add_handler(R.get_planet_handler("@planet_handler::noise_based_height_level_modifier").new())
	var liquid_handler = R.get_planet_handler("@planet_handler::area_based_liquid_generator").new()
	liquid_handler.liquid_data = {
		"@liquid_area:main:water" : {
			"priority" : 10,
			"percent_range" : Vector2i(0, 10),
		},
		"@liquid_area:main:lava" : {
			"priority" : 2,
			"percent_range" : Vector2i(0, 2),
		},
	}
	add_handler(liquid_handler)
	add_handler(preload("res://Mod/main/Planet/Earthlike/PlanetHandler/HeightBasedTerrainHandler.gd").new())
	add_handler(preload("res://Mod/main/Planet/Earthlike/PlanetHandler/LiquidModifyTerrains.gd").new())
	add_handler(preload("res://Mod/main/Planet/Earthlike/PlanetHandler/PlacementGenerator.gd").new())
