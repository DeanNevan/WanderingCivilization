extends Node3D

class Icosahedron:
	var PHI := (1 + sqrt(5)) / 2.0;
	var radius = sqrt(1 * 1 + PHI * PHI)
	var X = 1.0
	var Z = PHI
	var N = 0.0
	#var top_points := PackedVector3Array()
	#var bottom_points := PackedVector3Array()
	var VERTICES := PackedVector3Array([
		Vector3(-X, N, Z),
		Vector3( X, N, Z),
		Vector3(-X, N,-Z),
		Vector3( X, N,-Z),
		
		Vector3( N, Z, X),
		Vector3( N, Z,-X),
		Vector3( N,-Z, X),
		Vector3( N,-Z,-X),
		
		Vector3( Z, X, N),
		Vector3(-Z, X, N),
		Vector3( Z,-X, N),
		Vector3(-Z,-X, N),
	])
	var TRIANGLES := PackedVector3Array([
		Vector3(0, 4, 1),
		Vector3(0, 9, 4),
		Vector3(9, 5, 4),
		Vector3(4, 5, 8),
		Vector3(4, 8, 1),
		
		Vector3(8, 10, 1),
		Vector3(8, 3, 10),
		Vector3(5, 3, 8),
		Vector3(5, 2, 3),
		Vector3(2, 7, 3),
		
		Vector3(7, 10, 3),
		Vector3(7, 6, 10),
		Vector3(7, 11, 6),
		Vector3(11, 0, 6),
		Vector3(0, 1, 6),
		
		Vector3(6, 1, 10),
		Vector3(9, 0, 11),
		Vector3(9, 11, 2),
		Vector3(9, 2, 5),
		Vector3(7, 2, 11),
	])
	
	func _init():
		pass
		#top_points.append(Vector3(0, 0, 1))
		#for i in 5:
			#top_points.append(Vector3(
				#S * cos(i * 2 * PI / 5.0),
				#S * sin(i * 2 * PI / 5.0),
				#C
			#))
		#for i in top_points.size():
			#bottom_points.append(Vector3(-top_points[i].x, top_points[i].y, -top_points[i].z))
		#ico_points = top_points.duplicate()
		#ico_points.append_array(bottom_points)
		#for i in 5:
			#TRIANGLES.append(Vector3(0, i + 1, (i + 1) % 5 + 1))
		#for i in 5:
			#TRIANGLES.append(Vector3(6, i + 7, (i + 1) % 5 + 7))
		#for i in 5:
			#TRIANGLES.append(Vector3(i + 1, (i + 1) % 5 + 1, (7 - i) % 5 + 7))
		#for i in 5:
			#TRIANGLES.append(Vector3(i + 1, (7 - i) % 5 + 7, (8 - i) % 5 + 7))

var Scene_marker_box_3d : PackedScene = preload("res://Assets/Scene/MarkerBox3D/MarkerBox3D.tscn")
var logger : Logger = LoggerManager.register_logger(self, "SphereGridGenerator", Logger.Level.DEBUG)

@onready
var mesh_pentagon : Mesh = $SimpleRegularPentagon/Pentagon.mesh
@onready
var mesh_hexagon : Mesh = $SimpleRegularHexagon/Hexagon.mesh

var normal_to_faces := {}
var face_to_polygon := {}
var polygon_to_faces := {}
var polygon_count := 0
var edge_count := 0
var corner_count := 0
var corners := []
var edges := []
var polygons := []
var latitude_to_polygons := {}
var marker_to_edge := {} # <Vector2i(corner1.id, corner2.id) : Edge>
var flag_arctic_polygon := false
var arctic_polygon : SphereGrid.Polygon

var PAD := 2

func is_vector3_equal(vec1 : Vector3, vec2 : Vector3) -> bool:
	return abs(vec1.x - vec2.x) < 0.03 && abs(vec1.y - vec2.y) < 0.03 && abs(vec1.z - vec2.z) < 0.03

func vector3_to_string(vector : Vector3, pad := PAD) -> String:
	var string : String = "%%.%df,%%.%df,%%.%df" % [pad, pad, pad]
	string = string % [vector.x, vector.y, vector.z]
	return string

#func test():
	#var mesh := ArrayMesh.new()
	#mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, $SimpleRegularHexagon/Hexagon.mesh.surface_get_arrays(0))
	#var mdt := MeshDataTool.new()
	#mdt.create_from_surface(mesh, 0)
	#var vertexes := []
	#var center := Vector3()
	#for i in mdt.get_vertex_count():
		#vertexes.append(i)
		#center += mdt.get_vertex(i)
	#center /= 6
	#var labels := []
	#await get_tree().create_timer(1).timeout
	#var base_vector : Vector3 = mdt.get_vertex(0) - center
	#for i in 6:
		#var new_label := Label3D.new()
		#new_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		#new_label.no_depth_test = true
		#new_label.text = str(i)
		#labels.append(new_label)
		#add_child(new_label)
		#new_label.position = mdt.get_vertex(i)
		#var vector_a : Vector3 = mdt.get_vertex(i) - center
		#var rad_a = vector_a.signed_angle_to(base_vector, mdt.get_face_normal(1))
		#if rad_a < 0:
			#rad_a += 2 * PI
		#print("%d:%s" % [i, str(rad_a)])
		#print(mdt.get_face_normal(1))
	#await get_tree().create_timer(1).timeout

func work(idx : int):
	#await(test())
	
	print(rad_to_deg(Vector3(0, -1, 1).signed_angle_to(Vector3.FORWARD, Vector3.RIGHT)))
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, get_node("GoldbergSphere_Freq_%d/GD_%d" % [idx, idx]).mesh.surface_get_arrays(0))
	var mdt := MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	
	#var arr := [
		#Vector2i(92, 2), Vector2i(92, 1), Vector2i(94, 1), Vector2i(94, 2), Vector2i(93, 2), Vector2i(93, 1)
	#]
	#for vec in arr:
		#var face_idx = vec.x
		#var edge_idx = mdt.get_face_edge(face_idx, vec.y)
		#var vertex0 = mdt.get_edge_vertex(edge_idx, 0)
		#var vertex1 = mdt.get_edge_vertex(edge_idx, 1)
		#var new_label := Label3D.new()
		#new_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		#new_label.no_depth_test = true
		#new_label.text = str(vertex0)
		#new_label.position = mdt.get_vertex(vertex0)
		#add_child(new_label)
		#
		#new_label = Label3D.new()
		#new_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		#new_label.no_depth_test = true
		#new_label.text = str(vertex1)
		#new_label.position = mdt.get_vertex(vertex1)
		#add_child(new_label)
	
	for vertex_idx in mdt.get_vertex_count():
		var vertex_pos : Vector3 = mdt.get_vertex(vertex_idx)
		var flag := false
		for _corner in corners:
			var corner : SphereGrid.Corner = _corner
			if (corner.center - vertex_pos).length() < 0.001:
				flag = true # 重合
				break
		if !flag:
			var new_corner := SphereGrid.Corner.new(vertex_pos)
			corner_count += 1
			corners.append(new_corner)
			new_corner.idx = corners.size() - 1
			new_corner.uv = mdt.get_vertex_uv(vertex_idx)
	
	for f in mdt.get_face_count():
		var normal : Vector3 = mdt.get_face_normal(f)
		var target := []
		var flag := false
		for vec in normal_to_faces:
			if is_vector3_equal(normal, vec):
				target = normal_to_faces[vec]
				flag = true
				break
		if flag:
			target.append(f)
		else:
			normal_to_faces[normal] = [f]
	var counter := {
		1 : 0,
		2 : 0,
		3 : 0,
		4 : 0,
		5 : 0,
		6 : 0,
	}
	for normal in normal_to_faces:
		var average_normal := Vector3()
		var faces_count : int = normal_to_faces[normal].size()
		counter[faces_count] += 1
		for face_idx in normal_to_faces[normal]:
			average_normal += mdt.get_face_normal(face_idx)
		average_normal /= faces_count
		var new_polygon : SphereGrid.Polygon
		if faces_count == 3:
			new_polygon = SphereGrid.Pentagon.new()
		else:
			new_polygon = SphereGrid.Hexagon.new()
		polygon_count += 1
		polygons.append(new_polygon)
		new_polygon.idx = polygon_count - 1
		new_polygon.normal = average_normal
		if (average_normal - Vector3.UP).length() < 0.001:
			assert(!flag_arctic_polygon)
			flag_arctic_polygon = true
			arctic_polygon = new_polygon
		polygon_to_faces[new_polygon] = []
		var edges := [] # 寻找多边形的外边，剔除内部三角面在多边形内部的边，最长的几条就是内边
		for face_idx in normal_to_faces[normal]:
			face_to_polygon[face_idx] = new_polygon
			polygon_to_faces[new_polygon].append(face_idx)
			for edge_idx in 3:
				edges.append(Vector2i(face_idx, edge_idx))
		edges.sort_custom(
			func(a : Vector2i, b : Vector2i): 
				return (
					(mdt.get_vertex(mdt.get_edge_vertex(mdt.get_face_edge(a.x, a.y), 0)) - 
					mdt.get_vertex(mdt.get_edge_vertex(mdt.get_face_edge(a.x, a.y), 1))).length() <
					(mdt.get_vertex(mdt.get_edge_vertex(mdt.get_face_edge(b.x, b.y), 0)) - 
					mdt.get_vertex(mdt.get_edge_vertex(mdt.get_face_edge(b.x, b.y), 1))).length()
				)
		)
		edges.resize(new_polygon.SIZE)
		
		var center := Vector3()
		var vertexes := []
		#print("===new polygon===")
		#print("edges:%s" % str(edges))
		for vec in edges:
			var face_idx = vec.x
			var edge_idx = mdt.get_face_edge(face_idx, vec.y)
			var vertex_idx = mdt.get_edge_vertex(edge_idx, 0)
			var vertex_pos : Vector3 = mdt.get_vertex(vertex_idx)
			var flag := false
			for i in vertexes:
				var target_pos : Vector3 = mdt.get_vertex(i)
				if abs(vertex_pos.x - target_pos.x) < 0.0001 && abs(vertex_pos.y - target_pos.y) < 0.0001 && abs(vertex_pos.z - target_pos.z) < 0.0001:
					flag = true
					break
			if !flag:
				vertexes.append(vertex_idx)
				center += mdt.get_vertex(vertex_idx)
			flag = false
			vertex_idx = mdt.get_edge_vertex(edge_idx, 1)
			vertex_pos = mdt.get_vertex(vertex_idx)
			for i in vertexes:
				var target_pos : Vector3 = mdt.get_vertex(i)
				if abs(vertex_pos.x - target_pos.x) < 0.0001 && abs(vertex_pos.y - target_pos.y) < 0.0001 && abs(vertex_pos.z - target_pos.z) < 0.0001:
					flag = true
					break
			if !flag:
				vertexes.append(vertex_idx)
				center += mdt.get_vertex(vertex_idx)
				
		center /= new_polygon.SIZE
		new_polygon.center = center
		var base_vector : Vector3 = mdt.get_vertex(vertexes[0]) - center
		vertexes.sort_custom(
			func (a : int, b : int):
				var vector_a : Vector3 = mdt.get_vertex(a) - center
				var vector_b : Vector3 = mdt.get_vertex(b) - center
				var rad_a = vector_a.signed_angle_to(base_vector, average_normal)
				var rad_b = vector_b.signed_angle_to(base_vector, average_normal)
				if rad_a < 0:
					rad_a += 2 * PI
				if rad_b < 0:
					rad_b += 2 * PI
				return rad_a < rad_b
		)
		for vertex_idx in vertexes:
			var vertex_pos : Vector3 = mdt.get_vertex(vertex_idx)
			for _corner in corners:
				var corner : SphereGrid.Corner = _corner
				if (corner.center - vertex_pos).length() < 0.0001:
					new_polygon.add_corner(corner)
					corner.add_polygon(new_polygon)
					break
	print("counter:%s" % str(counter))
	for _corner in corners:
		var corner : SphereGrid.Corner = _corner
		for polygon in corner.polygons:
			for neighbour in corner.polygons:
				if !polygon.neighbours.has(neighbour) && polygon != neighbour:
					polygon.add_neighbour(neighbour)
	
	#var labels := []
	#var label_center := Label3D.new()
	#label_center.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	#label_center.no_depth_test = true
	#label_center.text = "X"
	#label_center.modulate = Color.RED
	#add_child(label_center)
	#
	#await get_tree().create_timer(2).timeout
	#for i in 6:
		#var new_label := Label3D.new()
		#new_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		#new_label.no_depth_test = true
		#new_label.text = str(i)
		#labels.append(new_label)
		#add_child(new_label)
	#for _polygon in polygon_to_faces:
		#var polygon : SphereGrid.Polygon = _polygon
		#labels[5].visible = polygon is SphereGrid.Hexagon
		#label_center.position = polygon.center
		#for i in 6:
			#if (i == 5) && polygon is SphereGrid.Pentagon:
				#break
			#labels[i].position = polygon.corners[i].center
		#$RayCast3D.position = polygon.center
		#$RayCast3D.target_position = polygon.normal
		#await get_tree().create_timer(0.1).timeout
		##if polygon.SIZE == 5:
			##await get_tree().create_timer(10).timeout
		#
	
	for _polygon in polygon_to_faces:
		var polygon : SphereGrid.Polygon = _polygon
		for i in polygon.SIZE:
			var corner1 : SphereGrid.Corner = polygon.corners[i]
			var corner2 : SphereGrid.Corner = polygon.corners[(i + 1) % polygon.SIZE]
			var marker := Vector2i(min(corner1.idx, corner2.idx), max(corner1.idx, corner2.idx))
			if !marker_to_edge.has(marker):
				var new_edge := SphereGrid.Edge.new()
				edge_count += 1
				new_edge.idx = edge_count - 1
				edges.append(new_edge)
				new_edge.add_corner(corner1)
				new_edge.add_corner(corner2)
				corner1.add_edge(new_edge)
				corner2.add_edge(new_edge)
				var polygon_counter := {}
				for p in corner1.polygons:
					if !polygon_counter.has(p):
						polygon_counter[p] = 1
					else:
						polygon_counter[p] += 1
				for p in corner2.polygons:
					if !polygon_counter.has(p):
						polygon_counter[p] = 1
					else:
						polygon_counter[p] += 1
				for p in polygon_counter:
					if polygon_counter[p] == 1:
						new_edge.add_upright_polygon(p)
					else:
						new_edge.add_side_polygon(p)
				marker_to_edge[marker] = new_edge
			polygon.add_edge(marker_to_edge[marker])
	
	for _edge in marker_to_edge.values():
		var edge : SphereGrid.Edge = _edge
		for c in edge.corners:
			for e in c.edges:
				if !edge.edges.has(e) && e != edge:
					edge.add_edge(e)
	
	# BFS标记多边形网格坐标
	var visited := PackedByteArray()
	visited.resize(polygon_count)
	var queue := []
	arctic_polygon.location.x = 0
	arctic_polygon.location.y = 0
	queue.append(arctic_polygon.idx)
	visited[arctic_polygon.idx] = true
	latitude_to_polygons[0] = [arctic_polygon]
	while !queue.is_empty():
		var polygon_idx : int = queue.front()
		var polygon : SphereGrid.Polygon = polygons[polygon_idx]
		queue.pop_front()
		for n in polygon.neighbours:
			if !visited[n.idx]:
				visited[n.idx] = true
				n.location.x = polygon.location.x + 1
				queue.push_back(n.idx)
				if !latitude_to_polygons.has(n.location.x):
					latitude_to_polygons[n.location.x] = [n]
				else:
					latitude_to_polygons[n.location.x].append(n)
	for i in latitude_to_polygons:
		var same_latitude_polygons : Array = latitude_to_polygons[i]
		if same_latitude_polygons.size() == 1:
			continue
		same_latitude_polygons.sort_custom(
			func (a : SphereGrid.Polygon, b : SphereGrid.Polygon):
				var rad_a = a.center.signed_angle_to(Vector3.FORWARD, Vector3.UP)
				var rad_b = b.center.signed_angle_to(Vector3.FORWARD, Vector3.UP)
				if rad_a < 0:
					rad_a += 2 * PI
				if rad_b < 0:
					rad_b += 2 * PI
				return rad_a < rad_b
				pass
		)
		for j in same_latitude_polygons.size():
			same_latitude_polygons[j].location.y = j
	
	
	
	mesh.clear_surfaces()
	mdt.commit_to_surface(mesh)
	var new_mesh_instance := MeshInstance3D.new()
	new_mesh_instance.mesh = mesh
	add_child(new_mesh_instance)
	
	
	
	#for _polygon in polygons:
		#var polygon : SphereGrid.Polygon = _polygon
		#var new_label := Label3D.new()
		#add_child(new_label)
		#new_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		#new_label.no_depth_test = true
		#new_label.text = str(polygon.location)
		#new_label.font_size = 12
		#new_label.outline_size = 1
		#new_label.position = polygon.center
	
	var grid := SphereGrid.new()
	grid.polygons = polygons
	grid.edges = edges
	grid.corners = corners
	grid.polygon_count = polygon_count
	grid.edge_count = edge_count
	grid.corner_count = corner_count
	grid.latitude_count = latitude_to_polygons.size()
	grid.latitude_to_polygons = latitude_to_polygons
	grid.scale_level = idx
	grid.save_data()

func _ready():
	work(2)
	


