extends Node
class_name TerritoryManager

signal territory_changed

class Territory:
	var terrains := {}
	var core := false
	var id := ""
	var manager : TerritoryManager
	func _init(_id : String, _manager : TerritoryManager):
		id = _id
		manager = _manager
	func size() -> int:
		return terrains.size()
	func set_core(_core):
		core = _core
	func has_core() -> bool:
		return core
	func add_terrain(_terrain : PlanetTerrain):
		terrains[_terrain] = true
		_terrain.set_territory(id, self)
	func remove_terrain(_terrain : PlanetTerrain):
		if terrains.has(_terrain):
			if terrains[_terrain]:
				terrains.erase(_terrain)
		if _terrain.get_territory(id) == self:
			_terrain.remove_territory(id)
	func update_core(cores := {}):
		for t in terrains:
			if !terrains[t]:
				continue
			if cores.has(t):
				set_core(true)
				return
		set_core(false)
	func clear():
		for terrain in terrains:
			terrain.remove_territory(id)

@export var id := ""

var civilization : Civilization
func set_civilization(_civilization):
	civilization = _civilization

var territories := []
var cores := {}
var terrains_counter := {}

func _init(_id, _civilization = civilization):
	id = _id
	civilization = _civilization

func clear():
	for territory in territories:
		territory.clear()
	territories.clear()
	cores.clear()
	terrains_counter.clear()
	pass

func add_core(_terrain : PlanetTerrain):
	cores[_terrain] = true
	if is_instance_valid(_terrain.get_territory(id)):
		_terrain.get_territory(id).update_core(cores)
		territory_changed.emit()

func remove_core(_terrain : PlanetTerrain):
	cores.erase(_terrain)
	if is_instance_valid(_terrain.get_territory(id)):
		_terrain.get_territory(id).update_core(cores)
		territory_changed.emit()

func combine_territories(_territories : Array) -> Territory:
	var target_territory : Territory = _territories[0]
	for i in range(1, _territories.size()):
		for t in _territories[i].terrains:
			target_territory.add_terrain(t)
	target_territory.update_core(cores)
	return target_territory
	pass

func _update_when_new_terrain_added(_terrain : PlanetTerrain):
	var territory_to_terrains := {}
	#if is_instance_valid(_terrain.get_territory(id)):
		#if !territory_to_terrains.has(_terrain.get_territory(id)):
			#territory_to_terrains[_terrain.get_territory(id)] = [_terrain]
		#else:
			#territory_to_terrains[_terrain.get_territory(id)].append(_terrain)
	for n in _terrain.polygon.neighbours:
		if is_instance_valid(n.terrain.get_territory(id)):
			if !territory_to_terrains.has(n.terrain.get_territory(id)):
				territory_to_terrains[n.terrain.get_territory(id)] = [n.terrain]
			else:
				territory_to_terrains[n.terrain.get_territory(id)].append(n.terrain)
	if territory_to_terrains.size() == 0:
		var new_territory := Territory.new(id, self)
		new_territory.add_terrain(_terrain)
		new_territory.update_core(cores)
		territories.append(new_territory)
		territory_changed.emit()
		return
	if territory_to_terrains.size() == 1:
		var target_territory : Territory = territory_to_terrains.keys()[0]
		target_territory.add_terrain(_terrain)
		if cores.has(_terrain):
			target_territory.set_core(true)
		territory_changed.emit()
		return
	var target_territory : Territory = combine_territories(territory_to_terrains.keys())
	#var target_territory : Territory = territory_to_terrains.keys()[0]
	target_territory.add_terrain(_terrain)
	if cores.has(_terrain):
		target_territory.set_core(true)
	territory_changed.emit()
	pass

func _update_when_new_terrain_removed(_terrain : PlanetTerrain):
	var territory_to_terrains := {}
	for n in _terrain.polygon.neighbours:
		if is_instance_valid(n.terrain.get_territory(id)):
			if !territory_to_terrains.has(n.terrain.get_territory(id)):
				territory_to_terrains[n.terrain.get_territory(id)] = [n.terrain]
			else:
				territory_to_terrains[n.terrain.get_territory(id)].append(n.terrain)
	if territory_to_terrains.size() == 0:
		var target_territory : Territory = _terrain.get_territory(id)
		target_territory.remove_terrain(_terrain)
		#target_territory.update_core(cores)
		territories.erase(target_territory)
		territory_changed.emit()
		return
	assert(territory_to_terrains.size() == 1)
	var target_territory : Territory = territory_to_terrains.keys()[0]
	var terrains : Array = territory_to_terrains[target_territory]
	if terrains.size() == 1:
		target_territory.remove_terrain(_terrain)
		if cores.has(_terrain):
			target_territory.update_core(cores)
		territory_changed.emit()
		return
	
	territories.erase(target_territory)
	
	var temp_territories := []
	for t in terrains:
		var flag := true
		for i in temp_territories:
			if i.terrains.has(t):
				flag = false
				break
		if !flag:
			continue
		
		var new_territory := Territory.new(id, self)
		
		#bfs
		var queue := [t]
		var visited := {}
		while !queue.is_empty():
			var terrain : PlanetTerrain = queue.back()
			queue.pop_back()
			visited[terrain] = true
			new_territory.add_terrain(terrain)
			for n in terrain.polygon.neighbours:
				if visited.has(n.terrain):
					continue
				queue.push_back(n.terrain)
		
		new_territory.update_core(cores)
		temp_territories.append(new_territory)
	
	territory_changed.emit()


func add_terrain_count(_terrain : PlanetTerrain):
	if !terrains_counter.has(_terrain):
		terrains_counter[_terrain] = 1
		_update_when_new_terrain_added(_terrain)
	else:
		terrains_counter[_terrain] += 1

func remove_terrain_count(_terrain : PlanetTerrain):
	if terrains_counter.has(_terrain):
		terrains_counter[_terrain] -= 1
		if terrains_counter[_terrain] == 0:
			_update_when_new_terrain_removed(_terrain)
			terrains_counter.erase(_terrain)


