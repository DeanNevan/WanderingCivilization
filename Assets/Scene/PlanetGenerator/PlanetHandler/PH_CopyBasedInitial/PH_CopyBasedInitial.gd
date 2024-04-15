extends PlanetHandler
class_name PH_CopyBasedInitial

var logger := LoggerManager.register_logger(self, "PH_CopyBasedInitial")

func _init():
	self.id = "@planet_handler::initial"



func handle_async():
	await super.handle_async()
	
	logger.debug("处理模块：基于复制，初始化地块")
	var time_start : int = Time.get_ticks_msec()
	
	var target_planet : Planet = R.planets_preload[planet.scale_level]
	target_planet.copy_to(planet)
	
	for t in target_planet.terrains:
		var new_terrain : PlanetTerrain = R.Scene_PlanetTerrain.instantiate()
		t.copy_to(new_terrain, true)
		planet.add_terrain(new_terrain)
	
	planet.init_radius_rate()
	
	var time_end : int = Time.get_ticks_msec()
	logger.debug("耗时:%dms" % (time_end - time_start))

