extends Object
class_name SphereGrid

class Location:
	var x := 0
	var y := 0
	
	func _init(_x := 0, _y := 0):
		x = _x
		y = _y
	
	func _to_string():
		return "<%d,%d>" % [x, y]
	
	func serialize() -> Dictionary:
		var data := {
			"x" : x,
			"y" : y,
		}
		return data
	
	func unserialize(data : Dictionary) -> void:
		x = data["x"]
		y = data["y"]
	
	

class Polygon:
	var idx := -1
	var SIZE := 0
	var location := SphereGrid.Location.new()
	var center := Vector3()
	var normal := Vector3.UP
	var edges := []
	var corners := []
	var neighbours := []
	var flag
	var uv := Vector2(-1, -1):
		get:
			if uv.x < -0.5:
				uv = Vector2()
				for i in corners:
					uv += i.uv
				uv /= SIZE
			return uv
	
	
	var terrain : PlanetTerrain
	
	func add_edge(new_edge : SphereGrid.Edge):
		edges.append(new_edge)
		assert(edges.size() <= SIZE)
	
	func add_corner(new_corner : SphereGrid.Corner):
		corners.append(new_corner)
		assert(corners.size() <= SIZE)
	
	func add_neighbour(new_polygon : SphereGrid.Polygon):
		neighbours.append(new_polygon)
		assert(neighbours.size() <= SIZE)
	
	func serialize() -> Dictionary:
		var data := {
			"idx" : idx,
			"location" : location.serialize(),
			"size" : SIZE,
			"center" : var_to_str(center),
			"normal" : var_to_str(normal),
			"edges" : [],
			"corners" : [],
			"neighbours" : [],
		}
		
		for _edge in edges:
			var edge : SphereGrid.Edge = _edge
			data["edges"].append(edge.idx)
		for _corner in corners:
			var corner : SphereGrid.Corner = _corner
			data["corners"].append(corner.idx)
		for _neighbour in neighbours:
			var neighbour : SphereGrid.Polygon = _neighbour
			data["neighbours"].append(neighbour.idx)
		
		return data
	
	# 仅反序列化非外键信息
	func unserialize(data : Dictionary, do_foreign_key := false, global_polygons := [], global_edges := [], global_corners := []) -> void:
		idx = data["idx"]
		location.unserialize(data["location"])
		SIZE = data["size"]
		center = str_to_var(data["center"])
		normal = str_to_var(data["normal"])
		if do_foreign_key:
			for _edge in data["edges"]:
				add_edge(global_edges[_edge])
			for _corner in data["corners"]:
				add_corner(global_corners[_corner])
			for _neighbour in data["neighbours"]:
				add_neighbour(global_polygons[_neighbour])
		pass
	pass

class Hexagon:
	extends Polygon
	func _init():
		SIZE = 6

class Pentagon:
	extends Polygon
	func _init():
		SIZE = 5

class Edge:
	var idx := -1
	var corners := [] # 大小一定为2
	var side_polygons := [] # 大小一定为2
	var upright_polygons := [] # 大小一定为2
	var edges := [] # 大小一定为4
	
	func add_corner(new_corner : SphereGrid.Corner):
		corners.append(new_corner)
		assert(corners.size() <= 2)
	
	func add_edge(new_edge : SphereGrid.Edge):
		edges.append(new_edge)
		assert(edges.size() <= 4)
	
	func add_side_polygon(new_polygon : SphereGrid.Polygon):
		side_polygons.append(new_polygon)
		assert(side_polygons.size() <= 2)
	
	func add_upright_polygon(new_polygon : SphereGrid.Polygon):
		upright_polygons.append(new_polygon)
		assert(upright_polygons.size() <= 2)
	
	func get_length() -> float:
		assert(corners.size() == 2)
		return (corners[0].center - corners[1].center).length()
	
	func another_corner(this_corner : SphereGrid.Corner):
		assert(corners.size() == 2)
		return corners[1] if corners[0] == this_corner else corners[0]
	
	func serialize() -> Dictionary:
		var data := {
			"idx" : idx,
			"corners" : [],
			"side_polygons" : [],
			"upright_polygons" : [],
			"edges" : [],
		}
		for _corner in corners:
			data["corners"].append(_corner.idx)
		for _polygon in side_polygons:
			data["side_polygons"].append(_polygon.idx)
		for _polygon in upright_polygons:
			data["upright_polygons"].append(_polygon.idx)
		for _edge in edges:
			data["edges"].append(_edge.idx)
		return data
	
	# 仅反序列化非外键信息
	func unserialize(data : Dictionary, do_foreign_key := false, global_polygons := [], global_edges := [], global_corners := []) -> void:
		idx = data["idx"]
		if do_foreign_key:
			for _edge in data["edges"]:
				add_edge(global_edges[_edge])
			for _corner in data["corners"]:
				add_corner(global_corners[_corner])
			for _polygon in data["side_polygons"]:
				add_side_polygon(global_polygons[_polygon])
			for _polygon in data["upright_polygons"]:
				add_upright_polygon(global_polygons[_polygon])
		pass
	
	pass

class Corner:
	var center := Vector3():
		set(_center):
			center = _center
	var edges := [] # 大小一定是3
	var polygons := [] # 大小一定是3
	var idx := -1
	var uv := Vector2()
	
	func _init(_center := Vector3()):
		center = _center
	
	func add_edge(new_edge : SphereGrid.Edge):
		edges.append(new_edge)
		assert(edges.size() <= 3)
	func add_polygon(new_polygon : SphereGrid.Polygon):
		polygons.append(new_polygon)
		assert(polygons.size() <= 3)
	
	func serialize() -> Dictionary:
		var data := {
			"idx" : idx,
			"center" : var_to_str(center),
			"uv" : var_to_str(uv),
			"edges" : [],
			"polygons" : [],
		}
		for _polygon in polygons:
			data["polygons"].append(_polygon.idx)
		for _edge in edges:
			data["edges"].append(_edge.idx)
		return data
	
	# 仅反序列化非外键信息
	func unserialize(data : Dictionary, do_foreign_key := false, global_polygons := [], global_edges := [], global_corners := []) -> void:
		idx = data["idx"]
		uv = str_to_var(data["uv"])
		center = str_to_var(data["center"])
		if do_foreign_key:
			for _edge in data["edges"]:
				add_edge(global_edges[_edge])
			for _polygon in data["polygons"]:
				add_polygon(global_polygons[_polygon])
		pass
	
	pass

var corners := []
var edges := []
var polygons := []

var SCALE_LEVELS := [1, 2, 3, 4]
var scale_level : int = SCALE_LEVELS[0]
#var SCALE_LEVEL_TO_POLYGON_COUNT := {
	#1 : 92,
	#2 : 362,
	#3 : 812,
	#4 : 1442,
#}

var polygon_count := 0
var edge_count := 0
var corner_count := 0

var latitude_count := 0
var latitude_to_polygons := {}

func serialize() -> Dictionary:
	var data := {
		"latitude_count" : latitude_count,
		"scale_level" : scale_level,
		"polygon_count" : polygon_count,
		"edge_count" : edge_count,
		"corner_count" : corner_count,
		"latitude_to_polygons" : {},
		"polygons" : {},
		"edges" : {},
		"corners" : {},
	}
	for _latitude in latitude_to_polygons:
		data["latitude_to_polygons"][_latitude] = []
		for _polygon in latitude_to_polygons[_latitude]:
			var polygon : SphereGrid.Polygon = _polygon
			data["latitude_to_polygons"][_latitude].append(polygon.idx)
	for _polygon in polygons:
		var polygon : SphereGrid.Polygon = _polygon
		data["polygons"][polygon.idx] = polygon.serialize()
	for _edge in edges:
		var edge : SphereGrid.Edge = _edge
		data["edges"][edge.idx] = edge.serialize()
	for _corner in corners:
		var corner : SphereGrid.Corner = _corner
		data["corners"][corner.idx] = corner.serialize()
	#
	return data

func unserialize(data : Dictionary) -> void:
	latitude_count = data["latitude_count"]
	scale_level = data["scale_level"]
	polygon_count = data["polygon_count"]
	edge_count = data["edge_count"]
	corner_count = data["corner_count"]
	for i in polygon_count:
		var polygon := SphereGrid.Polygon.new()
		polygons.append(polygon)
	for i in edge_count:
		var edge := SphereGrid.Edge.new()
		edges.append(edge)
	for i in corner_count:
		var corner := SphereGrid.Corner.new()
		corners.append(corner)
	for idx in data["polygons"]:
		var polygon : SphereGrid.Polygon = polygons[idx.to_int()]
		polygon.unserialize(data["polygons"][idx], true, polygons, edges, corners)
	for idx in data["edges"]:
		var edge : SphereGrid.Edge = edges[idx.to_int()]
		edge.unserialize(data["edges"][idx], true, polygons, edges, corners)
	for idx in data["corners"]:
		var corner : SphereGrid.Corner = corners[idx.to_int()]
		corner.unserialize(data["corners"][idx], true, polygons, edges, corners)
	
	for i in data["latitude_to_polygons"]:
		if !latitude_to_polygons.has(i):
			latitude_to_polygons[i.to_int()] = []
		for j in data["latitude_to_polygons"][i]:
			latitude_to_polygons[i.to_int()].append(polygons[j])
	return 

'''
Here's a sample on how to write and read from a file:

func save(content):
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_string(content)

func load():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	var content = file.get_as_text()
	return content
'''

func save_data():
	var data : Dictionary = serialize()
	var json_string = JSON.stringify(data)
	var file : FileAccess = FileAccess.open("res://Assets/ConstantData/SphereGridData/SphereGridData_%d.json" % scale_level, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()

func load_data(which_scale_level := 1):
	var file : FileAccess = FileAccess.open("res://Assets/ConstantData/SphereGridData/SphereGridData_%d.json" % which_scale_level, FileAccess.READ)
	var content : String = file.get_as_text()
	var json := JSON.new()
	var error : int = json.parse(content)
	if error == OK:
		var data_received : Dictionary = json.data
		unserialize(data_received)
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", content, " at line ", json.get_error_line())

