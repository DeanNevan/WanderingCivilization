extends Node

var TERRAIN_DIRT := preload("res://Assets/Terrains/TerrainDirt/TerrainDirt.tscn")
var TERRAIN_GRASS := preload("res://Assets/Terrains/TerrainGrass/TerrainGrass.tscn")
var TERRAIN_MARS := preload("res://Assets/Terrains/TerrainMars/TerrainMars.tscn")
var TERRAIN_SAND := preload("res://Assets/Terrains/TerrainSand/TerrainSand.tscn")
var TERRAIN_STONE := preload("res://Assets/Terrains/TerrainStone/TerrainStone.tscn")

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

var SUBSTANCE_BRINE = preload("res://Assets/Substances/SubstanceBrine/SubstanceBrine.tscn")
var SUBSTANCE_CLAY = preload("res://Assets/Substances/SubstanceClay/SubstanceClay.tscn")
var SUBSTANCE_CONGLOMERATE = preload("res://Assets/Substances/SubstanceConglomerate/SubstanceConglomerate.tscn")
var SUBSTANCE_DIRT = preload("res://Assets/Substances/SubstanceDirt/SubstanceDirt.tscn")
var SUBSTANCE_ELM = preload("res://Assets/Substances/SubstanceElm/SubstanceElm.tscn")
var SUBSTANCE_LIMESTONE = preload("res://Assets/Substances/SubstanceLimestone/SubstanceLimestone.tscn")
var SUBSTANCE_MAPLE = preload("res://Assets/Substances/SubstanceMaple/SubstanceMaple.tscn")
var SUBSTANCE_OAK = preload("res://Assets/Substances/SubstanceOak/SubstanceOak.tscn")
var SUBSTANCE_PURE_WATER = preload("res://Assets/Substances/SubstancePureWater/SubstancePureWater.tscn")
var SUBSTANCE_ROSEWOOD = preload("res://Assets/Substances/SubstanceRosewood/SubstanceRosewood.tscn")
var SUBSTANCE_STONE = preload("res://Assets/Substances/SubstanceStone/SubstanceStone.tscn")
var SUBSTANCE_CACTUS = preload("res://Assets/Substances/SubstanceCactus/SubstanceCactus.tscn")
var SUBSTANCE_COPPER_ORE = preload("res://Assets/Substances/SubtanceCopperOre/SubstanceCopperOre.tscn")
var SUBSTANCE_TIN_ORE = preload("res://Assets/Substances/SubstanceTinOre/SubstanceTinOre.tscn")
var SUBSTANCE_LEAD_ORE = preload("res://Assets/Substances/SubstanceLeadOre/SubstanceLeadOre.tscn")
var SUBSTANCE_CRYSTAL = preload("res://Assets/Substances/SubstanceCrystal/SubstanceCrystal.tscn")

enum RESOURCE{
	FOREST_OAK
}

enum TECH_TYPE{
	PRIMITIVE#原始
	GLOBAL#通用
	MATH#数学
	THEORY_SCIENCE#科技理论
	THEORY_MAGIC#魔法理论
	THEORY_THEOLOGY#神学理论
	APPLY#应用技术
	SUPER#超级
}

enum BUILDING_TYPE{
	PRIMITIVE
	GLOBAL
	SCIENCE
	MAGIC
	THEOLOGY
	SUPER
}

enum COMBINATION_DRAW_SETTINGS_MODE{
	RANDOM
	PLAIN
	DESERT
	DESOLATE
}

enum GREAT_MAN{#伟人的种类
	RULER#统治者
	RESEARCHER#研究者
	GENERAL#将军
	ARTIST#艺术家
	BUILDER#建造者
	OFFICER#官员
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
	
	