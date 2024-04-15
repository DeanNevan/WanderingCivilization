extends PlanetHandler
class_name PH_HeightBasedTerrainModifier

"""
一般规定优先级最高为10
最低为1
{
	"@terrain:main:grass_plain" : {
		3 : [0],
		2 : [-1, 1],
		1 : [-2, 2],
	}
}
"""
var terrains_height_level_priorities := {}

var height_level_to_terrains_data := {
	
}



var logger := LoggerManager.register_logger(self, "PH_HeightBasedTerrainModifier")

func _init():
	self.id = "@planet_handler::height_based_terrain_modifier"

func init_priorities_via_height_level():
	for h in range(-8, 9, 1):
		height_level_to_terrains_data[h] = {
			"total" : 0,
			"terrains" : {}
		}
	
	for terrain_id in terrains_height_level_priorities:
		for p in terrains_height_level_priorities[terrain_id]:
			for h in terrains_height_level_priorities[terrain_id][p]:
				height_level_to_terrains_data[h]["total"] += p
				height_level_to_terrains_data[h]["terrains"][terrain_id] = p
		#var terrain_gd : GDScript = R.terrains.get(terrain_id)
		#if terrain_gd == null:
			#logger.error("no such terrain file(%s)" % terrain_id)
			#continue
		#var terrain : PlanetTerrain = terrain_gd.new()
	
	#for _terrain in planet.terrains:
		#var terrain : PlanetTerrain = _terrain
		#terrains_priorities[terrain] = height_level_to_terrains_data[terrain.height_level]

func edit_terrain_priority_via_height_level(_terrain : PlanetTerrain):
	for i in height_level_to_terrains_data[_terrain.height_level]["terrains"]:
		planet.edit_terrain_priority(_terrain, i, height_level_to_terrains_data[_terrain.height_level]["terrains"][i])

func handle_async():
	await super.handle_async()
	
	logger.debug("处理模块：基于海拔等级，初始化地形")
	var time_start : int = Time.get_ticks_msec()
	
	init_priorities_via_height_level()
	for _terrain in planet.terrains:
		handle_terrain(_terrain)
	
	for _terrain in planet.terrains:
		var terrain : PlanetTerrain = _terrain
		planet.random_pick_terrain(terrain)
	for _terrain in planet.terrains:
		var terrain : PlanetTerrain = _terrain
		terrain.update_current_env_factors()
	
	var time_end : int = Time.get_ticks_msec()
	logger.debug("耗时:%dms" % (time_end - time_start))
	pass



func handle_terrain(_terrain : PlanetTerrain):
	edit_terrain_priority_via_height_level(_terrain)


