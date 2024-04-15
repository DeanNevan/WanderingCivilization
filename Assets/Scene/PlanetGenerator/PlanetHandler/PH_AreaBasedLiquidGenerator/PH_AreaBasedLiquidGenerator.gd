extends PlanetHandler
class_name PH_AreaBasedLiquidGenerator

var logger := LoggerManager.register_logger(self, "PH_LiquidGenerator")
"""
{
	<liquid_area_id> : {
		"priority" : <priority>,
		"percent_range" : percent_range>,
	}
}
"""
@export var liquid_data := {}

var each_up_limit := {}
var each_low_limit := {}

"""
{
	<liquid_area_id> : {
		"total" : 10,
		"terrains" : []
		"height_from" : 0,
		"height_to" : 0,
	}
}
"""
var pools := {}

"""
{
	<liquid_area_id> : []
}
"""
var visited := {}

func handle_async():
	await super.handle_async()
	
	logger.debug("处理模块：基于面积，生成流体区域")
	var time_start : int = Time.get_ticks_msec()
	
	var next_selection := {}
	for id in liquid_data:
		visited[id] = []
		pools[id] = []
		next_selection[id] = 0
		each_up_limit[id] = ceil(planet.terrains.size() * liquid_data[id]["percent_range"].y / 100.0)
		each_low_limit[id] = ceil(planet.terrains.size() * liquid_data[id]["percent_range"].x / 100.0)
		for i in planet.terrains.size():
			var flag := false
			if is_instance_valid(planet.terrains[i].liquid):
				flag = true
				break
			visited[id].append(flag)
	for _terrain in planet.terrains:
		handle_terrain(_terrain)
	
	var old_liquid_data = liquid_data.duplicate()
	
	var total := 0
	for i in liquid_data:
		total += liquid_data[i]["priority"]
	var temp := []
	
	var total_pools_size : int = 0
	for id in pools:
		total_pools_size += pools[id].size()
	
	for s in total_pools_size:
		if total == 0:
			break
		var p : int = planet.rander_for_generation.randi() % total
		var liquid_area_id : String
		for l_id in liquid_data:
			var pp : int = liquid_data[l_id]["priority"]
			if p < pp:
				liquid_area_id = l_id
				break
			p -= pp
		
		while true:
			if next_selection[liquid_area_id] >= pools[liquid_area_id].size():
				liquid_data.erase(liquid_area_id)
				total = 0
				for i in liquid_data:
					total += liquid_data[i]["priority"]
				break
			
			var pool = pools[liquid_area_id][next_selection[liquid_area_id]]
			next_selection[liquid_area_id] += 1
			
			var i = pool["height_to"] - pool["height_from"]
			#print("%s:%d" % [liquid_area_id, pool["terrains"][i].size()])
			
			var flag := true
			for j in pool["terrains"][i]:
				if temp.has(j):
					flag = false
					break
			if !flag:
				continue
			
			
			var liquid_area : PlanetLiquidArea = R.get_liquid_area(liquid_area_id).new()
			liquid_area.height_level = pool["height_to"]
			liquid_area.set_terrains(pool["terrains"][i])
			for j in pool["terrains"][i]:
				temp.append(j)
			planet.add_liquid_area(liquid_area)
			break
	
	liquid_data = old_liquid_data
	
	var time_end : int = Time.get_ticks_msec()
	logger.debug("耗时:%dms" % (time_end - time_start))


func handle_terrain(_terrain : PlanetTerrain):
	for liquid_area_id in visited:
		if visited[liquid_area_id][_terrain.idx]:
			continue
		
		var lowest_terrain : PlanetTerrain = _terrain
		while true:
			var flag := false
			for n in lowest_terrain.polygon.neighbours:
				var t : PlanetTerrain = n.terrain
				if visited[liquid_area_id][t.idx] == true:
					return
				if t.height_level < lowest_terrain.height_level:
					lowest_terrain = t
					flag = true
					break
			if !flag:
				break
		
		# 扩散寻找液体区域
		pools[liquid_area_id].append({
			"total" : 0,
			"terrains" : [],
			"height_from" : 0,
			"height_to" : 0,
		})
		pools[liquid_area_id][pools[liquid_area_id].size() - 1]["height_from"] = lowest_terrain.height_level
		var height_limit : int = lowest_terrain.height_level
		while true:
			var temp := []
			var queue := [lowest_terrain]
			var flag := true
			while !queue.is_empty():
				var t : PlanetTerrain = queue.back()
				queue.pop_back()
				if temp.has(t):
					continue
				temp.append(t)
				
				if temp.size() > each_up_limit[liquid_area_id]:
					#if liquid_area_id == "@liquid_area:main:lava":
						#print("temp.size():%d" % temp.size())
						#print("each_up_limit[liquid_area_id]:%d" % each_up_limit[liquid_area_id])
					flag = false
					#var queue2 := [lowest_terrain]
					#var visited2 := []
					#for i in planet.terrains.size():
						#visited2.append(false)
					#while !queue2.is_empty():
						#var t2 : PlanetTerrain = queue2.back()
						#queue2.pop_back()
						#visited2[t2.idx] = true
						#if t2.height_level == height_limit:
							#visited[t2.idx] = true
						#for n in t2.polygon.neighbours:
							#if !visited2[n.idx]:
								#queue2.append(n.terrain)
					break
				for n in t.polygon.neighbours:
					if visited[liquid_area_id][n.terrain.idx]:
						flag = false
						break
					if n.terrain.height_level <= height_limit:
						queue.append(n.terrain)
				if !flag:
					break
			if !flag:
				height_limit -= 1
				break
			pools[liquid_area_id][pools[liquid_area_id].size() - 1]["terrains"].append(temp) 
			height_limit += 1
		if pools[liquid_area_id][pools[liquid_area_id].size() - 1]["terrains"].size() == 0:
			pools[liquid_area_id].pop_back()
		else:
			pools[liquid_area_id][pools[liquid_area_id].size() - 1]["height_to"] = height_limit
			var t = pools[liquid_area_id][pools[liquid_area_id].size() - 1]["height_to"] - pools[liquid_area_id][pools[liquid_area_id].size() - 1]["height_from"]
			pools[liquid_area_id][pools[liquid_area_id].size() - 1]["total"] = pools[liquid_area_id][pools[liquid_area_id].size() - 1]["terrains"][t].size()
			if pools[liquid_area_id][pools[liquid_area_id].size() - 1]["total"] < each_low_limit[liquid_area_id]:
				pools[liquid_area_id].pop_back()
			else:
				for i in pools[liquid_area_id][pools[liquid_area_id].size() - 1]["terrains"][t]:
					visited[liquid_area_id][i.idx] = true
		pass
		
		#var area := PlanetLiquidArea.new(liquid_id, _terrain.height_level)
		#for r in result:
			#area.new_resource(r)
		#liquid_areas.append(area)


