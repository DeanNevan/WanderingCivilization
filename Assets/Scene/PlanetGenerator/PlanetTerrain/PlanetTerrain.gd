extends Node3D
class_name PlanetTerrain

var id := "@terrain::default"
var terrain_name := "@str::default_terrain_name"
var material_id := "@material::default_terrain"

@onready var _Elements = $Elements

class Vertex:
	var pos := Vector3()
	var height_level := 0
	var height_offset := 0.0
	var idx := -1
	var overlap_vertexes := []
	var terrain : PlanetTerrain
	func _init(_pos = pos):
		pos = _pos

var env_factors_id_provide := {}
var env_factors_id_provide_neighbour := {}
var current_env_factors := {}

var liquid : TerrainResourceLiquid
var placements := {}
var other_elements := []
var all_elements := []

var planet : Planet
var polygon : SphereGrid.Polygon

var height_level := 0
var idx := -1

var material_to_faces_idx := {}

var neighbour_to_self_faces_idx := {}

var vertexes := []
# 最外圈0，中圈1，内圈2
func get_round_via_vertex(idx : int):
	if polygon.SIZE == 6:
		if idx >= 0 && idx <= 17:
			return 0
		elif idx >= 18 && idx <= 29:
			return 1
		elif idx >= 30 && idx <= 35:
			return 2
		else:
			return 3
	else:
		if idx >= 0 && idx <= 14:
			return 0
		elif idx >= 18 && idx <= 24:
			return 1
		elif idx >= 25 && idx <= 29:
			return 2
		else:
			return 3
	pass

func get_vertexes_range_via_round(_round : int) -> Vector2i:
	if polygon.SIZE == 6:
		if _round == 0:
			return Vector2i(0, 17)
		elif _round == 1:
			return Vector2i(18, 29)
		elif _round == 2:
			return Vector2i(30, 35)
		else:
			return Vector2i(36, 36)
	else:
		if _round == 0:
			return Vector2i(0, 14)
		elif _round == 1:
			return Vector2i(15, 24)
		elif _round == 2:
			return Vector2i(25, 29)
		else:
			return Vector2i(30, 30)

func get_faces_range_via_round(_round : int) -> Vector2i:
	if polygon.SIZE == 6:
		if _round == 0:
			return Vector2i(0, 29)
		elif _round == 1:
			return Vector2i(29, 47)
		else:
			return Vector2i(48, 53)
	else:
		if _round == 0:
			return Vector2i(0, 24)
		elif _round == 1:
			return Vector2i(25, 39)
		else:
			return Vector2i(40, 44)

var faces_idx := [] # 存储Vector3i，xyz分别表示三角面三个顶点的idx
# 最外圈0，中圈1，内圈2
func get_round_via_face_idx(idx : int):
	if polygon.SIZE == 6:
		if idx >= 0 && idx < 30:
			return 0
		elif idx >= 30 && idx < 48:
			return 1
		else:
			return 2
	else:
		if idx >= 0 && idx < 25:
			return 0
		elif idx >= 30 && idx < 40:
			return 1
		else:
			return 2

func get_corner_vertexes_via_round(_round : int):
	if polygon.SIZE == 5:
		if _round == 0:
			return [
				vertexes[0],
				vertexes[3],
				vertexes[6],
				vertexes[9],
				vertexes[12],
			]
		elif _round == 1:
			return [
				vertexes[15],
				vertexes[17],
				vertexes[19],
				vertexes[21],
				vertexes[23],
			]
		else:
			return [
				vertexes[25],
				vertexes[26],
				vertexes[27],
				vertexes[28],
				vertexes[29],
			]
	else:
		if _round == 0:
			return [
				vertexes[0],
				vertexes[3],
				vertexes[6],
				vertexes[9],
				vertexes[12],
				vertexes[15],
			]
		elif _round == 1:
			return [
				vertexes[18],
				vertexes[20],
				vertexes[22],
				vertexes[24],
				vertexes[26],
				vertexes[28],
			]
		else:
			return [
				vertexes[30],
				vertexes[31],
				vertexes[32],
				vertexes[33],
				vertexes[34],
				vertexes[35],
			]

func get_plane() -> Plane:
	return Plane(polygon.normal, get_center())

func get_axis_x() -> Vector3:
	var pos := Vector3()
	if polygon.SIZE == 5:
		pos += vertexes[25].pos
		pos += vertexes[27].pos
		pos /= 2
		return (pos - get_center()).normalized()
	else:
		pos += vertexes[31].pos
		pos += vertexes[32].pos
		pos /= 2
		return (pos - get_center()).normalized()

func get_axis_y() -> Vector3:
	return (vertexes[0].pos - get_center()).normalized()

func get_edge_len() -> float:
	return (vertexes[0].pos - vertexes[3].pos).length()

func get_face_center(idx : int) -> Vector3:
	var vec : Vector3i = faces_idx[idx]
	var p1 : Vector3 = vertexes[vec.x].pos
	var p2 : Vector3 = vertexes[vec.y].pos
	var p3 : Vector3 = vertexes[vec.z].pos
	return (p1 + p2 + p3) / 3

func get_face_normal(idx : int) -> Vector3:
	var vec : Vector3i = faces_idx[idx]
	var p1 : Vector3 = vertexes[vec.x].pos
	var p2 : Vector3 = vertexes[vec.y].pos
	var p3 : Vector3 = vertexes[vec.z].pos
	var normal := Vector3()
	return Math.get_normal_via_triangle(p1, p2, p3)

# offset_rate在0-1之间，要乘以三角顶点到三角中心的距离才是绝对偏移量
func random_pick_pos_around_face(idx : int, offset_rate := 0.5) -> Vector3:
	var center := get_face_center(idx)
	var vec : Vector3i = faces_idx[idx]
	var p1 : Vector3 = vertexes[vec.x].pos
	var p2 : Vector3 = vertexes[vec.y].pos
	var p3 : Vector3 = vertexes[vec.z].pos
	var arr := [p1, p2, p3]
	arr.shuffle()
	for i in arr:
		center += (i - center) * offset_rate
	return center

func get_center() -> Vector3:
	return vertexes[vertexes.size() - 1].pos
	pass

func add_other_element(_element : TerrainElement):
	if _element.is_inside_tree():
		_element.get_parent().remove_child(_element)
	other_elements.append(_element)
	all_elements.append(_element)
	_element.terrain = self
	_Elements.add_child(_element)
	update_current_env_factors()
	

func copy_to(target : PlanetTerrain, do_duplicate := false):
	if do_duplicate:
		target.polygon = polygon
		target.polygon.terrain = target
		target.neighbour_to_self_faces_idx = neighbour_to_self_faces_idx
		target.vertexes = vertexes.duplicate()
		for v in target.vertexes:
			v.terrain = target
		target.faces_idx = faces_idx
		target.idx = idx
	else:
		target.planet = planet
		target.polygon = polygon
		target.polygon.terrain = target
		target.height_level = height_level
		target.neighbour_to_self_faces_idx = neighbour_to_self_faces_idx
		target.vertexes = vertexes
		
		target.set_liquid(liquid)
		target.set_placements(placements.values())
		for e in other_elements:
			target.add_other_element(e)
		
		target.faces_idx = faces_idx
		target.idx = idx

func delete():
	queue_free()

func add_vertex(pos : Vector3):
	vertexes.append(Vertex.new(pos))
	vertexes[vertexes.size() - 1].idx = vertexes.size() - 1
	vertexes[vertexes.size() - 1].terrain = self

func init():
	if polygon.SIZE == 6:
		faces_idx = [
			Vector3i(0, 1, 18),
			Vector3i(1, 19, 18),
			Vector3i(1, 2, 19),
			Vector3i(2, 20, 19),
			Vector3i(2, 3, 20),
			Vector3i(3, 4, 20),
			Vector3i(4, 21, 20),
			Vector3i(4, 5, 21),
			Vector3i(5, 22, 21),
			Vector3i(5, 6, 22),
			Vector3i(6, 7, 22),
			Vector3i(7, 23, 22),
			Vector3i(7, 8, 23),
			Vector3i(8, 24, 23),
			Vector3i(8, 9, 24),
			Vector3i(9, 10, 24),
			Vector3i(10, 25, 24),
			Vector3i(10, 11, 25),
			Vector3i(11, 26, 25),
			Vector3i(11, 12, 26),
			Vector3i(12, 13, 26),
			Vector3i(13, 27, 26),
			Vector3i(13, 14, 27),
			Vector3i(14, 28, 27),
			Vector3i(14, 15, 28),
			Vector3i(15, 16, 28),
			Vector3i(16, 29, 28),
			Vector3i(16, 17, 29),
			Vector3i(17, 18, 29),
			Vector3i(17, 0, 18),
			Vector3i(18, 19, 30),
			Vector3i(19, 31, 30),
			Vector3i(19, 20, 31),
			Vector3i(20, 21, 31),
			Vector3i(21, 32, 31),
			Vector3i(21, 22, 32),
			Vector3i(22, 23, 32),
			Vector3i(23, 33, 32),
			Vector3i(23, 24, 33),
			Vector3i(24, 25, 33),
			Vector3i(25, 34, 33),
			Vector3i(25, 26, 34),
			Vector3i(26, 27, 34),
			Vector3i(27, 35, 34),
			Vector3i(27, 28, 35),
			Vector3i(28, 29, 35),
			Vector3i(29, 30, 35),
			Vector3i(29, 18, 30),
			Vector3i(30, 31, 36),
			Vector3i(31, 32, 36),
			Vector3i(32, 33, 36),
			Vector3i(33, 34, 36),
			Vector3i(34, 35, 36),
			Vector3i(35, 30, 36),
		]
	else:
		faces_idx = [
			Vector3i(0, 1, 15),
			Vector3i(1, 16, 15),
			Vector3i(1, 2, 16),
			Vector3i(2, 17, 16),
			Vector3i(2, 3, 17),
			Vector3i(3, 4, 17),
			Vector3i(4, 18, 17),
			Vector3i(4, 5, 18),
			Vector3i(5, 19, 18),
			Vector3i(5, 6, 19),
			Vector3i(6, 7, 19),
			Vector3i(7, 20, 19),
			Vector3i(7, 8, 20),
			Vector3i(8, 21, 20),
			Vector3i(8, 9, 21),
			Vector3i(9, 10, 21),
			Vector3i(10, 22, 21),
			Vector3i(10, 11, 22),
			Vector3i(11, 23, 22),
			Vector3i(11, 12, 23),
			Vector3i(12, 13, 23),
			Vector3i(13, 24, 23),
			Vector3i(13, 14, 24),
			Vector3i(14, 15, 24),
			Vector3i(14, 0, 15),
			Vector3i(15, 16, 25),
			Vector3i(16, 26, 25),
			Vector3i(16, 17, 26),
			Vector3i(17, 18, 26),
			Vector3i(18, 27, 26),
			Vector3i(18, 19, 27),
			Vector3i(19, 20, 27),
			Vector3i(20, 28, 27),
			Vector3i(20, 21, 28),
			Vector3i(21, 22, 28),
			Vector3i(22, 29, 28),
			Vector3i(22, 23, 29),
			Vector3i(23, 24, 29),
			Vector3i(24, 25, 29),
			Vector3i(24, 15, 25),
			Vector3i(25, 26, 30),
			Vector3i(26, 27, 30),
			Vector3i(27, 28, 30),
			Vector3i(28, 29, 30),
			Vector3i(29, 25, 30),
		]
	
	for i in polygon.SIZE:
		var vec : Vector3 = polygon.corners[(i + 1) % polygon.SIZE].center - polygon.corners[i].center
		var p1 = polygon.corners[i].center + vec / 3
		var p2 = polygon.corners[i].center + vec * 2.0 / 3
		
		if i == 0:
			add_vertex(polygon.corners[i].center)
		add_vertex(p1)
		add_vertex(p2)
		if i != polygon.edges.size() - 1:
			add_vertex(polygon.corners[(i + 1) % polygon.SIZE].center)
	
	# 做第一次内切
	var vertexes_middle := []
	for i in polygon.corners.size():
		var vec : Vector3 = (polygon.corners[i].center - polygon.center) * 2.0 / 3
		vec = polygon.center + vec
		vertexes_middle.append(vec)
	
	for i in polygon.SIZE:
		if i == 0:
			add_vertex(vertexes_middle[i])
		add_vertex((vertexes_middle[i] + vertexes_middle[(i + 1) % vertexes_middle.size()]) / 2)
		if i != vertexes_middle.size() - 1:
			add_vertex(vertexes_middle[(i + 1) % vertexes_middle.size()])
	
	# 做第二次内切
	for i in polygon.SIZE:
		var vec : Vector3 = (polygon.corners[i].center - polygon.center) / 3
		vec = polygon.center + vec
		add_vertex(vec)
	add_vertex(polygon.center)
	
	for v in vertexes.size():
		vertexes[v].idx = v
	
	var c := 18 if polygon.SIZE == 6 else 15
	var temp := {}
	for n in polygon.neighbours:
		var neighbour_terrain : PlanetTerrain = n.terrain
		for v in neighbour_terrain.vertexes:
			var min_dis_vertex
			var min_dis := 100000.0
			var cc := 0
			for self_v in vertexes:
				cc += 1
				if (polygon.SIZE == 5 && cc > 15) || (polygon.SIZE == 6 && cc > 18):
					break
				if v.pos.is_equal_approx(self_v.pos):
					self_v.overlap_vertexes.append(v)
					v.overlap_vertexes.append(self_v)
	
	for i in range(0, 30 if polygon.SIZE == 6 else 25, 5):
		var face_center := Vector3()
		face_center += vertexes[faces_idx[i].x].pos
		face_center += vertexes[faces_idx[i].y].pos
		face_center += vertexes[faces_idx[i].z].pos
		face_center /= 3
		var min_dis := 100000.0
		var min_nei : SphereGrid.Polygon
		for n in polygon.neighbours:
			if (n.center - face_center).length() < min_dis:
				min_dis = (n.center - face_center).length()
				min_nei = n
		neighbour_to_self_faces_idx[min_nei] = []
		for j in range(i, i + 5, 1):
			neighbour_to_self_faces_idx[min_nei].append(j)

func smoothen_edge():
	for v in get_vertexes_range_via_round(0).y + 1:
		var vertex = vertexes[v]
		
		#for vv in vertex.overlap_vertexes:
			#vv.pos = vertex.pos
		
		var middle_pos : Vector3 = vertex.pos
		for vv in vertex.overlap_vertexes:
			middle_pos += vv.pos
		middle_pos /= vertex.overlap_vertexes.size() + 1
		
		for vv in vertex.overlap_vertexes:
			vv.pos = middle_pos
		vertex.pos = middle_pos

func update_faces_material():
	material_to_faces_idx = {
		material_id : []
	}
	#for n in neighbour_to_self_faces_idx:
		#var t : PlanetTerrain = n.terrain
		#for f_idx in neighbour_to_self_faces_idx[n]:
			#if (f_idx % 5) % 2 == 0 and planet.rander_for_generation.randf() < 0.1:
				#if !material_to_faces_idx.has(t.material_id):
					#material_to_faces_idx[t.material_id] = []
				#material_to_faces_idx[t.material_id].append(f_idx)
				#if (f_idx % 5 == 4):
					#material_to_faces_idx[t.material_id].append(f_idx - 1)
				#else:
					#material_to_faces_idx[t.material_id].append(f_idx + 1)
			#else:
				#material_to_faces_idx[material_id].append(f_idx)
	#
	#for i in range(30 if polygon.SIZE == 6 else 25, faces_idx.size(), 1):
		#material_to_faces_idx[material_id].append(i)
	
	for i in faces_idx.size():
		material_to_faces_idx[material_id].append(i)

func init_display(array_mesh : ArrayMesh, material_to_st : Dictionary):
	update_faces_material()
	for m_id in material_to_faces_idx:
		for f_idx in material_to_faces_idx[m_id]:
			var st : SurfaceTool
			if !material_to_st.has(m_id):
				st = SurfaceTool.new()
				st.clear()
				st.begin(Mesh.PRIMITIVE_TRIANGLES)
				material_to_st[m_id] = st
			st = material_to_st[m_id]
			
			var p1 : Vector3 = vertexes[faces_idx[f_idx].x].pos
			var p2 : Vector3 = vertexes[faces_idx[f_idx].y].pos
			var p3 : Vector3 = vertexes[faces_idx[f_idx].z].pos
			st.set_uv(Vector2(0, 0))
			st.set_smooth_group(-1)
			#st.set_normal(polygon.normal)
			st.add_vertex(p1)
			
			st.set_uv(Vector2(0, 1))
			st.set_smooth_group(-1)
			#st.set_normal(polygon.normal)
			st.add_vertex(p2)
			
			st.set_uv(Vector2(0.866, 0.5))
			st.set_smooth_group(-1)
			#st.set_normal(polygon.normal)
			st.add_vertex(p3)
	
	for placement in placements.values():
		if is_instance_valid(placement):
			placement.init_display()
	
	#for i in faces_idx.size():
		#array_mesh.surface_set_material(i, R.default_material_for_terrain)

func add_placement(_placement : TerrainResourcePlacement):
	if !is_instance_valid(_placement):
		return
	if _placement.is_inside_tree():
		_placement.get_parent().remove_child(_placement)
	if is_instance_valid(placements.get(_placement.layer)):
		placements.get(_placement.layer).delete()
	placements[_placement.layer] = _placement
	_placement.terrain = self
	_Elements.add_child(_placement)
	all_elements.append(_placement)
	update_current_env_factors()

func set_placements(arr : Array):
	for i in arr:
		add_placement(i)

func set_liquid(_liquid : TerrainResourceLiquid):
	if !is_instance_valid(_liquid):
		return
	if _liquid.is_inside_tree():
		_liquid.get_parent().remove_child(_liquid)
	liquid = _liquid
	liquid.terrain = self
	_Elements.add_child(liquid)
	all_elements.append(liquid)
	update_current_env_factors()

func has_other_element(id : String) -> bool:
	for e in other_elements:
		if e.id == id:
			return true
	return false

func has_placement() -> bool:
	return placements.size() > 0

func has_liquid() -> bool:
	return is_instance_valid(liquid)

func get_placements() -> Dictionary:
	return placements

func get_liquid() -> TerrainResourceLiquid:
	return liquid

func get_current_env_factors():
	return current_env_factors

func get_env_factor_value(id : String) -> int:
	if current_env_factors.has(id):
		return current_env_factors.get(id)
	else:
		return 0

func edit_env_factor(id : String, value : int):
	if value == 0:
		return
	if !current_env_factors.has(id):
		current_env_factors[id] = value
	else:
		current_env_factors[id] += value


func update_current_env_factors():
	current_env_factors = {}
	for id in env_factors_id_provide:
		current_env_factors[id] = env_factors_id_provide[id]
	for _element in all_elements:
		for p in _element.env_factors_id_modification:
			edit_env_factor(p, _element.env_factors_id_modification[p])
	for n in polygon.neighbours:
		var t : PlanetTerrain = n.terrain
		for p in t.env_factors_id_provide_neighbour:
			edit_env_factor(p, t.env_factors_id_provide_neighbour[p])
		for _element in t.all_elements:
			for p in _element.env_factors_id_modification_neighbour:
				edit_env_factor(p, _element.env_factors_id_modification_neighbour[p])

func focus():
	pass

func unfocus():
	pass
