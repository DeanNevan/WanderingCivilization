extends Node3D
class_name TerrainElement

var id := "@element::default"
var info := "@str::default_element_info"
var element_name := "@str::default_element_name"

var terrain : PlanetTerrain

var env_factors_id_modification := {}
var env_factors_id_modification_neighbour := {}

func init():
	pass

func delete():
	queue_free()

#func terrain_modify():
	#pass
