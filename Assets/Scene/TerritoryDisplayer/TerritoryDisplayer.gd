extends Node3D
class_name TerritoryDisplayer

@onready var _MeshInstance3D = $MeshInstance3D
@onready var _MeshInstanceEdge3D = $MeshInstanceEdge3D

var territory_manager : TerritoryManager:
	set(_territory_manager):
		territory_manager = _territory_manager
		if !is_instance_valid(territory_manager):
			return
		if !territory_manager.is_connected("territory_changed", _on_territory_changed):
			territory_manager.connect("territory_changed", _on_territory_changed)

func set_territory_manager(_territory_manager):
	territory_manager = _territory_manager

var material_core : Material = preload("res://Assets/Material/MaterialTerritoryDisplayCore.tres")
var material_core_edge : Material = preload("res://Assets/Material/MaterialTerritoryDisplayCoreEdge.tres")
var material : Material = preload("res://Assets/Material/MaterialTerritoryDisplay.tres")
var material_edge : Material = preload("res://Assets/Material/MaterialTerritoryDisplay.tres")

var enabled := false:
	set(_enabled):
		enabled = _enabled
		update_display()
		if enabled:
			_on_territory_changed()

func _init(_territory_manager = territory_manager):
	territory_manager = _territory_manager

func _ready():
	update_display()

func update_display():
	visible = enabled

func _on_territory_changed():
	if !enabled:
		return
	
	var mesh := ArrayMesh.new()
	var mesh_edge := ArrayMesh.new()
	var st := SurfaceTool.new()
	var st_edge := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st_edge.begin(Mesh.PRIMITIVE_TRIANGLES)
	for t in territory_manager.territories:
		var territory : TerritoryManager.Territory = t
		for _terrain in territory.terrains:
			var terrain : PlanetTerrain = _terrain
			for f in terrain.faces_idx:
				
				var p1 : Vector3 = terrain.get_vertex_pos_of_liquid(f.x)
				var p2 : Vector3 = terrain.get_vertex_pos_of_liquid(f.y)
				var p3 : Vector3 = terrain.get_vertex_pos_of_liquid(f.z)
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
			
			for n in terrain.polygon.neighbours:
				if territory.terrains.has(n.terrain):
					continue
				var temp : Array = terrain.neighbour_to_self_faces_idx[n].duplicate()
				if temp[0] == 0:
					temp.append(terrain.get_faces_range_via_round(0).y)
				else:
					temp.append(temp[0] - 1)
				if temp[temp.size() - 2] == terrain.get_faces_range_via_round(0).y:
					temp.append(0)
				else:
					temp.append(temp[temp.size() - 2] + 1)
					
				for f_idx in temp:
					var p1 : Vector3 = terrain.get_vertex_pos_of_liquid(terrain.faces_idx[f_idx].x)
					var p2 : Vector3 = terrain.get_vertex_pos_of_liquid(terrain.faces_idx[f_idx].y)
					var p3 : Vector3 = terrain.get_vertex_pos_of_liquid(terrain.faces_idx[f_idx].z)
					
					st_edge.set_uv(Vector2(0, 0))
					st_edge.set_smooth_group(-1)
					st_edge.add_vertex(p1)
					
					st_edge.set_uv(Vector2(0, 1))
					st_edge.set_smooth_group(-1)
					st_edge.add_vertex(p2)
					
					st_edge.set_uv(Vector2(0.866, 0.5))
					st_edge.set_smooth_group(-1)
					st_edge.add_vertex(p3)
			
		st.generate_normals()
		st_edge.generate_normals()
		st.commit(mesh)
		st_edge.commit(mesh_edge)
		mesh.surface_set_material(mesh.get_surface_count() - 1, material_core if territory.core else material)
		mesh_edge.surface_set_material(mesh_edge.get_surface_count() - 1, material_core_edge if territory.core else material_edge)
	_MeshInstance3D.mesh = mesh
	_MeshInstanceEdge3D.mesh = mesh_edge
	pass

func enable():
	enabled = true

func disable():
	enabled = false
