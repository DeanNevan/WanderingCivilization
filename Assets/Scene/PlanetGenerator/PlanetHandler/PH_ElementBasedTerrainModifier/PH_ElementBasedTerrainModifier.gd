extends PlanetHandler
class_name PH_ElementBasedTerrainModifier

var logger := LoggerManager.register_logger(self, "PH_ElementBasedTerrainModifier")

func handle_async():
	await super.handle_async()
	logger.debug("处理模块：基于地形元素，修改地形本身")
	var time_start : int = Time.get_ticks_msec()
	
	for t in planet.terrains:
		handle_terrain(t)
		#for e in t.elements:
			#e.terrain_modify()
	
	for t in planet.terrains:
		planet.random_pick_terrain(t)
	
	var time_end : int = Time.get_ticks_msec()
	logger.debug("耗时:%dms" % (time_end - time_start))

func handle_terrain(_terrain : PlanetTerrain):
	pass
