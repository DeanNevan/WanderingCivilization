extends TerritoryManager
class_name CivilizationTerritoryManager

func _init(_civilization = civilization):
	id = "civilization"
	civilization = _civilization

func artificial_added(artificial : TerrainArtificial):
	var expand_borderland : int = artificial.expand_borderland
	var terrains : Array = artificial.terrain.get_neighbour_terrains_via_level(expand_borderland)
	for t in terrains:
		add_terrain_count(t)
	if artificial.core:
		add_core(artificial.terrain)
	pass

func artificial_removed(artificial : TerrainArtificial):
	var expand_borderland : int = artificial.expand_borderland
	var terrains : Array = artificial.terrain.get_neighbour_terrains_via_level(expand_borderland)
	for t in terrains:
		remove_terrain_count(t)
	if artificial.core:
		remove_core(artificial.terrain)
	pass
