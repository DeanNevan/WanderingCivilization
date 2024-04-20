extends PlanetHandler
class_name PH_FactorBasedPlacementGenerator

var logger := LoggerManager.register_logger(self, "PH_FactorBasedPlacementGenerator")

@export var placement_data := {}

func handle_terrain(t : PlanetTerrain):
	var t_factors : Dictionary = t.get_current_env_factors()
	for placement_id in placement_data:
		var flag := true
		
		var instance : TerrainResourcePlacement = R.get_element_instance(placement_id)
		
		if !instance.meet_requirements(t):
			continue
		
		var element_instance : TerrainElement = R.get_element_instance(placement_id)
		planet.edit_placement_priority(t, placement_id, element_instance.layer, placement_data[placement_id])

func handle_async():
	await super.handle_async()
	logger.debug("处理模块：基于环境因素，生成放置物资源")
	var time_start : int = Time.get_ticks_msec()
	
	for t in planet.terrains:
		t.update_current_env_factors()
		handle_terrain(t)
	
	for t in planet.terrains:
		planet.random_pick_placements(t)
	
	var time_end : int = Time.get_ticks_msec()
	logger.debug("耗时:%dms" % (time_end - time_start))
	
	
