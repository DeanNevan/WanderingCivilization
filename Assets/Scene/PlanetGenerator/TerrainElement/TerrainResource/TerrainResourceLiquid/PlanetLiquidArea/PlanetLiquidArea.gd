extends Node3D
class_name PlanetLiquidArea


var mesh_instance : MeshInstance3D

var id := "@element::default"
var liquid_id := "@element::default"
var liquid_resources := []

var planet : Planet

var terrains := []

var margin_

var height_level := 0

func _init(_height_level):
	height_level = _height_level

func _ready():
	mesh_instance = MeshInstance3D.new()
	#mesh_instance.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC
	add_child(mesh_instance)

func set_terrains(_terrains : Array):
	for t in _terrains:
		terrains.append(t)
		new_resource(t)

func new_resource(_terrain : PlanetTerrain):
	var liquid : TerrainResourceLiquid = R.get_element(liquid_id).new()
	liquid.terrain = _terrain
	liquid.liquid_area = self
	_terrain.set_liquid(liquid)
	liquid_resources.append(liquid)

func set_mesh(mesh):
	mesh_instance.mesh = mesh
	update_material()

func update_material():
	mesh_instance.material_override = R.get_material(liquid_resources[0].material_id)


func cal_pos_via_height_level(pos : Vector3, _height_level : int = height_level):
	if !is_instance_valid(planet):
		return Vector3()
	return planet.cal_pos_via_height_level(pos.normalized() * 1.01 * planet.radius_rate, height_level)

func init_display():
	if liquid_resources.size() == 0:
		return
	var mesh := ArrayMesh.new()
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var temp := []
	for _liquid in liquid_resources:
		if !is_instance_valid(_liquid):
			continue
		var liquid : TerrainResourceLiquid = _liquid
		var terrain : PlanetTerrain = liquid.terrain
		for n in terrain.polygon.neighbours:
			if !terrains.has(n.terrain):
				temp.append([terrain, n.terrain])
		for f in terrain.faces_idx:
			var p1 : Vector3 = terrain.vertexes[f.x].pos
			var p2 : Vector3 = terrain.vertexes[f.y].pos
			var p3 : Vector3 = terrain.vertexes[f.z].pos
			st.set_smooth_group(-1)
			st.add_vertex(cal_pos_via_height_level(p1, height_level))
			st.set_smooth_group(-1)
			st.add_vertex(cal_pos_via_height_level(p2, height_level))
			st.set_smooth_group(-1)
			st.add_vertex(cal_pos_via_height_level(p3, height_level))
	
	for tt in temp:
		var t1 : PlanetTerrain = tt[0]
		var t2 : PlanetTerrain = tt[1]
		var f_idx_range : Vector2i = t2.get_faces_range_via_round(0)
		var min_dis := 100000.0
		var min_i := 0
		for i in range(0, f_idx_range.y, 5):
			var center := Vector3()
			var vec : Vector3i = t2.faces_idx[i]
			center += t2.vertexes[vec.x].pos
			center += t2.vertexes[vec.y].pos
			center += t2.vertexes[vec.z].pos
			center /= 3
			if (center - t1.polygon.center).length() < min_dis:
				min_dis = (center - t1.polygon.center).length()
				min_i = i
		for f_idx in range(min_i, min_i + 5, 1):
			var f : Vector3i = t2.faces_idx[f_idx]
			var p1 : Vector3 = t2.vertexes[f.x].pos
			var p2 : Vector3 = t2.vertexes[f.y].pos
			var p3 : Vector3 = t2.vertexes[f.z].pos
			st.set_smooth_group(-1)
			st.add_vertex(planet.cal_pos_via_height_level(p1.normalized() * 1.01 * planet.radius_rate, height_level))
			st.set_smooth_group(-1)
			st.add_vertex(planet.cal_pos_via_height_level(p2.normalized() * 1.01 * planet.radius_rate, height_level))
			st.set_smooth_group(-1)
			st.add_vertex(planet.cal_pos_via_height_level(p3.normalized() * 1.01 * planet.radius_rate, height_level))
	
	st.generate_normals()
	st.commit(mesh)
	set_mesh(mesh)
	

