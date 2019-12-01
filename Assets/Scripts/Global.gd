extends Node

var LAYER_AREA = 100
var LAYER_HEIGHT = 100
var LAYER = preload("res://Assets/Terrains/Layer/Layer.tscn")

var LAYERS = preload("res://Assets/Terrains/Layers/Layers.tscn")

var TERRAIN_DIRT := preload("res://Assets/Terrains/TerrainDirt/TerrainDirt.tscn")
var MARGIN_DIRT := preload("res://Assets/Art/Hexagons-pack/BasicPack/PNG/Tiles/Terrain/Dirt/dirt_01.png")
var TERRAIN_GRASS := preload("res://Assets/Terrains/TerrainGrass/TerrainGrass.tscn")
var MARGIN_GRASS := preload("res://Assets/Art/Hexagons-pack/BasicPack/PNG/Tiles/Terrain/Grass/grass_18.png")
var TERRAIN_MARS := preload("res://Assets/Terrains/TerrainMars/TerrainMars.tscn")
var MARGIN_MARS := preload("res://Assets/Art/Hexagons-pack/BasicPack/PNG/Tiles/Terrain/Mars/mars_01.png")
var TERRAIN_SAND := preload("res://Assets/Terrains/TerrainSand/TerrainSand.tscn")
var MARGIN_SAND := preload("res://Assets/Art/Hexagons-pack/BasicPack/PNG/Tiles/Terrain/Sand/sand_01.png")
var TERRAIN_STONE := preload("res://Assets/Terrains/TerrainStone/TerrainStone.tscn")
var MARGIN_STONE := preload("res://Assets/Art/Hexagons-pack/BasicPack/PNG/Tiles/Terrain/Stone/stone_01.png")

var TERRAINS = [TERRAIN_DIRT, TERRAIN_GRASS, TERRAIN_MARS, TERRAIN_SAND, TERRAIN_STONE]

###y=0###
var NEIGHBOUR_VECTOR_1 = [Vector2(1, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(0, -1)]
###y<0并且abs(y)为奇数，或者，y>0并且abs(y)为偶数###
var NEIGHBOUR_VECTOR_2 = [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1)]
###else###
var NEIGHBOUR_VECTOR_3 = [Vector2(1, -1), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1)]

enum TERRAIN{
	DIRT
	GRASS
	MARS
	SAND
	STONE
}

enum ELEMENT_INIT_SETTINGS_MODE{
	AVERAGE
	RANDOM
	LOW_TO_HIGH
	HIGH_TO_LOW
	REAL
}

enum COMBINATION_DRAW_SETTINGS_MODE{
	RANDOM
	PLAIN
	DESERT
	DESOLATE
}

enum LAYERS_COUNT_SETTINGS_MODE{
	RANDOM
}

enum SURFACE_LAYER_SETTINGS_MODE{
	RANDOM
}

enum LAYERS_RESOURCES_SETTINGS_MODE{
	RANDOM
}

func judge_neighbour_vector(location):
	var neighbour_vector = Vector2()
	if location.y == 0:
		neighbour_vector = NEIGHBOUR_VECTOR_1
	elif (location.y < 0 and fmod(abs(location.y), 2) == 1) or (location.y > 0 and fmod(abs(location.y), 2) == 0):
		neighbour_vector = NEIGHBOUR_VECTOR_2
	else:
		neighbour_vector = NEIGHBOUR_VECTOR_3
	return neighbour_vector

func get_position_with_location(location):
	var m = 0
	var n = 0
	#print(location.y)
	if fmod(abs(location.y), 2) == 0:
		#偶数
		m = location.x * 120
	elif fmod(abs(location.y), 2) == 1:
		#奇数
		if location.y > 0:
			m = 60 + location.x * 120
		else:
			m = - 60 + location.x * 120
	n = 60 * sqrt(3) * location.y
	
	return(Vector2(m, n))
	
	