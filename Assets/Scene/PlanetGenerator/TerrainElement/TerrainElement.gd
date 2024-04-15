extends Node3D
class_name TerrainElement

var id := "@element::default"
var info := "@str::info_default_element"
var element_name := "@str::name_default_element"

var terrain : PlanetTerrain

var env_factors_id_modification := {}
var env_factors_id_modification_neighbour := {}

func init():
	pass

func delete():
	queue_free()

#func terrain_modify():
	#pass
