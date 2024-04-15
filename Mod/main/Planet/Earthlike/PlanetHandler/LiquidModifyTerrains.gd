extends PH_ElementBasedTerrainModifier

#岩浆和水修改地形
func handle_terrain(_terrain : PlanetTerrain):
	super.handle_terrain(_terrain)
	var liquid : TerrainResourceLiquid = _terrain.get_liquid()
	if !is_instance_valid(liquid):
		return
	if liquid.id == "@element:main:resource_liquid_lava":
		planet.edit_terrain_priority(_terrain, "@terrain:main:rock", 100)
		planet.edit_terrain_priority(_terrain, "@terrain:main:desert", 20)
		planet.edit_terrain_priority(_terrain, "@terrain:main:snow_field", -100)
		for n in _terrain.polygon.neighbours:
			var t : PlanetTerrain = n.terrain
			planet.edit_terrain_priority(t, "@terrain:main:desert", 10)
			planet.edit_terrain_priority(t, "@terrain:main:rock", 50)
			planet.edit_terrain_priority(t, "@terrain:main:snow_field", -50)
	elif liquid.id == "@element:main:resource_liquid_water":
		planet.edit_terrain_priority(_terrain, "@terrain:main:grass_plain", 20)
		planet.edit_terrain_priority(_terrain, "@terrain:main:loess_land", 5)
		for n in _terrain.polygon.neighbours:
			var t : PlanetTerrain = n.terrain
			planet.edit_terrain_priority(t, "@terrain:main:grass_plain", 10)
			planet.edit_terrain_priority(t, "@terrain:main:loess_land", 3)
	
