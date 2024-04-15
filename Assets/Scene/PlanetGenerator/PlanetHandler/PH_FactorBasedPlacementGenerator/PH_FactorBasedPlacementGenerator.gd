extends PlanetHandler
class_name PH_FactorBasedPlacementGenerator

var logger := LoggerManager.register_logger(self, "PH_FactorBasedPlacementGenerator")

"""
{
	<placement_id> : {
		"priority" : 3,
		"require" : {
			<factor_id> : 2,
			<factor_id> : 1,
		},
		"black_list_factors" : [
			<factor_id>
		],
		"white_list_terrains" : [
			<terrain_id>
		],
		"black_list_terrains" : [
			<terrain_id>
		]
	}
}
"""
@export var placement_data := {}

func handle_terrain(t : PlanetTerrain):
	var t_factors : Dictionary = t.get_current_env_factors()
	for placement_id in placement_data:
		var flag := true
		
		var instance : TerrainResourcePlacement = R.get_element_instance(placement_id)
		if instance.only_with_liquid and !t.has_liquid():
			continue
		
		if !instance.can_with_liquid and t.has_liquid():
			continue
		
		#if placement_id == "@element:main:resource_stone":
			#print(t_factors)
		
		if placement_data[placement_id]["white_list_terrains"].size() > 0:
			flag = false
			for terrain_id in placement_data[placement_id]["white_list_terrains"]:
				if t.id == terrain_id:
					flag = true
					break
		else:
			flag = true
		if !flag:
			continue
		
		for terrain_id in placement_data[placement_id]["black_list_terrains"]:
			if t.id == terrain_id:
				flag = false
				break
		if !flag:
			continue
		
		for factor_id in placement_data[placement_id]["black_list_factors"]:
			if t_factors.has(factor_id):
				if t_factors[factor_id] > 0:
					flag = false
					break
		if !flag:
			continue
		
		flag = true
		for factor_id in placement_data[placement_id]["require"]:
			if t_factors.has(factor_id):
				if t_factors[factor_id] < placement_data[placement_id]["require"][factor_id]:
					flag = false
					break
			else:
				flag = false
				break
		if !flag:
			continue
		planet.edit_placement_priority(t, placement_id, placement_data[placement_id]["priority"])

func handle_async():
	await super.handle_async()
	logger.debug("处理模块：基于环境因素，生成放置物资源")
	var time_start : int = Time.get_ticks_msec()
	
	for t in planet.terrains:
		t.update_current_env_factors()
		handle_terrain(t)
	
	for t in planet.terrains:
		planet.random_pick_placement(t)
	
	var time_end : int = Time.get_ticks_msec()
	logger.debug("耗时:%dms" % (time_end - time_start))
	
	
