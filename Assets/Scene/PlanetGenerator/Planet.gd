extends Node3D
class_name Planet

signal terrain_focused(terrain)
signal terrain_unfocused(terrain)
signal terrain_selected(terrain)
signal terrain_unselected(terrain)

var id := "@planet::default"

@export_range(1, 4)
var scale_level := 1
@export_range(1, 10)
var radius_rate : float = 10
@export_range(0, 1, 0.01)
var resource_richness := 0.5
@export_range(0.01, 1, 0.01)
var HEIGHT_EACH_LEVEL := 0.3


@onready
var _Terrains : Node3D = $Terrains
@onready var _Handlers = $Handlers
@onready var _LightLiquidAreaManager = $LightLiquidAreaManager

@onready
var _TerrainsMeshInstance : MeshInstance3D = $TerrainsMeshInstance
@onready var _LiquidAreas = $LiquidAreas

@onready var _PlanetInteractionManager = $PlanetInteractionManager




var terrains := []
var liquid_areas := []

var logger : Logger = LoggerManager.register_logger(self, "Planet")

var max_height := 0
var min_height := 0

var grid := SphereGrid.new()

"""
{
	<terrain> : {
		"total" : 0,
		"terrains" : {
			<terrain_id> : 2,
			<terrain_id> : 3,
		}
	}
}
"""
var terrains_priorities := {
	
}
"""
{
	<terrain> : {
		"total" : 0,
		"placements" : {
			<placement_id> : 2,
			<placement_id> : 3,
		}
	}
}
"""
var placements_priorities := {}

var handlers := []
var id_to_handlers := {}

var material_to_st := {
	
}
var surface_to_material_id := {
	
}

var rander_for_generation := RandomNumberGenerator.new()

func copy_to(target : Planet):
	target.grid = grid



func add_handler(handler : PlanetHandler):
	handlers.append(handler)
	handler.planet = self
	_Handlers.add_child(handler)
	id_to_handlers[handler.id] = handler

func add_terrain(_terrain : PlanetTerrain):
	_Terrains.add_child(_terrain)
	terrains.append(_terrain)
	_terrain.planet = self
	_terrain.idx = terrains.size() - 1

func add_liquid_area(_area : PlanetLiquidArea):
	liquid_areas.append(_area)
	_area.planet = self
	_LiquidAreas.add_child(_area)

func change_terrain(idx : int, target : PlanetTerrain):
	var origin
	_Terrains.add_child(target)
	if terrains.size() > idx and is_instance_valid(terrains[idx]):
		origin = terrains[idx]
	if is_instance_valid(origin):
		terrains_priorities[target] = terrains_priorities[origin]
		terrains_priorities.erase(origin)
		origin.copy_to(target)
		origin.delete()
	terrains[idx] = target
	pass

func init_grid():
	grid.load_data(scale_level)

func init_radius_rate():
	logger.debug("init_radius_rate")
	var time_start : int = Time.get_ticks_msec()
	
	for p in grid.polygons:
		p.center = p.center.normalized() * radius_rate
	for c in grid.corners:
		c.center = c.center.normalized() * radius_rate
	for t in terrains:
		for v in t.vertexes:
			v.pos = v.pos.normalized() * radius_rate
	
	var time_end : int = Time.get_ticks_msec()
	logger.debug("耗时:%dms" % (time_end - time_start))

func init():
	init_grid()
	init_radius_rate()
	#init_liquid_area_lights()

func init_liquid_area_lights():
	_LightLiquidAreaManager.init(radius_rate)

func generate_async():
	await get_tree().process_frame
	
	logger.debug("星球<%s>生成，种子:%d" % [name, rander_for_generation.seed])
	var time_start : int = Time.get_ticks_msec()
	
	init()
	for h in handlers:
		await h.handle_async()
	
	var time_end : int = Time.get_ticks_msec()
	logger.debug("星球<%s>结束生成，耗时:%dms" % [name, (time_end - time_start)])
	
	logger.debug("星球<%s>初始化渲染" % [name])
	time_start = Time.get_ticks_msec()
	init_display()
	time_end = Time.get_ticks_msec()
	logger.debug("星球<%s>结束初始化渲染，耗时:%dms" % [name, (time_end - time_start)])

func find_handler_by_id(id : String):
	return id_to_handlers.get(id)

func init_display():
	for t in terrains:
		t.smoothen_edge()
	var array_mesh := ArrayMesh.new()
	for t in terrains:
		t.init_display(array_mesh, material_to_st)
	#st.set_smooth_group(0)
	var c := 0
	for m_id in material_to_st:
		surface_to_material_id[c] = m_id
		c += 1
		var st : SurfaceTool = material_to_st[m_id]
		st.generate_normals()
		st.commit(array_mesh)
	
	for s_idx in surface_to_material_id:
		array_mesh.surface_set_material(s_idx, R.get_material(surface_to_material_id[s_idx]))
	
	_TerrainsMeshInstance.mesh = array_mesh
	
	for a in liquid_areas:
		a.init_display()

func cal_pos_via_height_level(_pos : Vector3, _level : int):
	return _pos + _pos.normalized() * _level * HEIGHT_EACH_LEVEL

func update_mesh_data():
	max_height = -10000
	min_height = 10000
	for _terrain in terrains:
		var terrain : PlanetTerrain = _terrain
		if terrain.height_level > max_height:
			max_height = terrain.height_level
		if terrain.height_level < min_height:
			min_height = terrain.height_level
		
		for _vertex in terrain.vertexes:
			var height_level = _vertex.height_level + terrain.height_level
			_vertex.pos += _vertex.pos.normalized() * HEIGHT_EACH_LEVEL * height_level
		
		#if terrain.height_level != 0:
		#
			#var marker : MarkerLabel3D = MarkerManager.new_marker_label_3d()
			#add_child(marker)
			#marker.font_size = 32 * radius_rate
			##marker.scale = Vector3(1, 1, 1)
			#marker.outline_size = 2 * radius_rate
			#marker.position = terrain.vertexes[terrain.vertexes.size() - 1].pos
			#marker.text = str(terrain.height_level)
			#marker.modulate.a = 0.1

func edit_placement_priority(_terrain : PlanetTerrain, _id : String, _layer : int, _priority : int):
	if !placements_priorities.has(_terrain):
		placements_priorities[_terrain] = {
			_layer : {
				"total" : 0,
				"placements" : {}
			}
		}
	elif !placements_priorities[_terrain].has(_layer):
		placements_priorities[_terrain][_layer] = {
			"total" : 0,
			"placements" : {}
		}
	if placements_priorities[_terrain][_layer]["placements"].has(_id):
		var v : int = placements_priorities[_terrain][_layer]["placements"][_id]
		if _priority >= 0:
			placements_priorities[_terrain][_layer]["placements"][_id] += _priority
			placements_priorities[_terrain][_layer]["total"] += _priority
		elif v >= abs(_priority):
			placements_priorities[_terrain][_layer]["placements"][_id] += _priority
			placements_priorities[_terrain][_layer]["total"] += _priority
		else:
			placements_priorities[_terrain][_layer]["placements"].erase(_id)
			placements_priorities[_terrain][_layer]["total"] -= v
	else:
		if _priority > 0:
			placements_priorities[_terrain][_layer]["placements"][_id] = _priority
			placements_priorities[_terrain][_layer]["total"] += _priority

func random_pick_placements(_terrain : PlanetTerrain):
	if !placements_priorities.has(_terrain):
		return
	if rander_for_generation.randf() > resource_richness:
		return
	for layer in placements_priorities[_terrain]:
		var total : int = placements_priorities[_terrain][layer]["total"]
		if total <= 0:
			return
		var p : int = rander_for_generation.randi() % total
		var placement_id : String
		for p_id in placements_priorities[_terrain][layer]["placements"]:
			var pp : int = placements_priorities[_terrain][layer]["placements"][p_id]
			if p < pp:
				placement_id = p_id
				break
			p -= pp
		add_placement(_terrain, placement_id, layer)

func add_placement(_terrain : PlanetTerrain, _placement_id : String, _layer : int):
	var script : GDScript = R.get_element(_placement_id)
	var new_placement : TerrainResourcePlacement = script.new()
	_terrain.add_placement(new_placement)

func edit_terrain_priority(_terrain : PlanetTerrain, _id : String, _priority : int):
	if !terrains_priorities.has(_terrain):
		terrains_priorities[_terrain] = {
			"total" : 0,
			"terrains" : {}
		}
	if terrains_priorities[_terrain]["terrains"].has(_id):
		var v : int = terrains_priorities[_terrain]["terrains"][_id]
		if _priority >= 0:
			terrains_priorities[_terrain]["terrains"][_id] += _priority
			terrains_priorities[_terrain]["total"] += _priority
		elif v >= abs(_priority):
			terrains_priorities[_terrain]["terrains"][_id] += _priority
			terrains_priorities[_terrain]["total"] += _priority
		else:
			terrains_priorities[_terrain]["terrains"].erase(_id)
			terrains_priorities[_terrain]["total"] -= v
	else:
		if _priority > 0:
			terrains_priorities[_terrain]["terrains"][_id] = _priority
			terrains_priorities[_terrain]["total"] += _priority

func random_pick_terrain(_terrain : PlanetTerrain):
	var total : int = terrains_priorities[_terrain]["total"]
	if total <= 0:
		return
	var p : int = rander_for_generation.randi() % total
	var terrain_id : String
	for t_id in terrains_priorities[_terrain]["terrains"]:
		var pp : int = terrains_priorities[_terrain]["terrains"][t_id]
		if p < pp:
			terrain_id = t_id
			break
		p -= pp
	set_terrain(_terrain, terrain_id)

func set_terrain(_terrain : PlanetTerrain, _terrain_id : String):
	var script : GDScript = R.get_terrain(_terrain_id)
	var new_terrain : PlanetTerrain = R.Scene_PlanetTerrain.instantiate()
	new_terrain.set_script(script)
	change_terrain(_terrain.idx, new_terrain)

func terrain_focus(_terrain : PlanetTerrain):
	_terrain.focus()
	terrain_focused.emit(_terrain)
	
	#print("focus:%s" % _terrain)
	pass

func terrain_unfocus(_terrain : PlanetTerrain):
	_terrain.unfocus()
	terrain_unfocused.emit(_terrain)
	
	#print("unfocus:%s" % _terrain)
	pass

func terrain_select(_terrain : PlanetTerrain):
	terrain_selected.emit(_terrain)

func terrain_unselect(_terrain : PlanetTerrain):
	terrain_unselected.emit(_terrain)

func get_focusing_terrain():
	return _PlanetInteractionManager.get_focusing_terrain()

func init_interaction():
	_PlanetInteractionManager.init_terrains()



#func update_mesh(_terrains := []):
	#var mesh = ArrayMesh.new()
	#mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, BoxMesh.new().get_mesh_arrays())
	#var mdt = MeshDataTool.new()
	#mdt.create_from_surface(mesh, 0)
	#for i in range(mdt.get_vertex_count()):
		#var vertex = mdt.get_vertex(i)
		## In this example we extend the mesh by one unit, which results in separated faces as it is flat shaded.
		#vertex += mdt.get_vertex_normal(i)
		## Save your change.
		#mdt.set_vertex(i, vertex)
	#mesh.clear_surfaces()
	#mdt.commit_to_surface(mesh)
	#var mi = MeshInstance.new()
	#mi.mesh = mesh
	#add_child(mi)
	
