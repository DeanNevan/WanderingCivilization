extends Mod
func _init():
	self.id = "main"
	self.mod_name = "@str:main:mod_name"
	self.terrains = {
		"@terrain:main:grass_plain" : "res://Mod/main/Terrain/TerrainGrassPlain/TerrainGrassPlain.gd",
		"@terrain:main:rock" : "res://Mod/main/Terrain/TerrainRock/TerrainRock.gd",
		"@terrain:main:desert" : "res://Mod/main/Terrain/TerrainDesert/TerrainDesert.gd",
		"@terrain:main:snow_field" : "res://Mod/main/Terrain/TerrainSnowField/TerrainSnowField.gd",
		"@terrain:main:loess_land" : "res://Mod/main/Terrain/TerrainLoessLand/TerrainLoessLand.gd",
	}
	self.liquid_areas = {
		"@liquid_area:main:water" : "res://Mod/main/Element/Resource/Liquid/LiquidAreaWater.gd",
		"@liquid_area:main:lava" : "res://Mod/main/Element/Resource/Liquid/LiquidAreaLava.gd",
	}
	self.materials = {
		"@material:main:grass_plain" : "res://Mod/main/Material/Material_TerrainGrassPlain.tres",
		"@material:main:rock" : "res://Mod/main/Material/FromModel/Rock.tres",
		"@material:main:desert" : "res://Mod/main/Material/Material_TerrainDesert.tres",
		"@material:main:snow_field" : "res://Mod/main/Material/FromModel/snow.tres",
		"@material:main:loess_land" : "res://Mod/main/Material/Material_TerrainLoessLand.tres",
		"@material:main:liquid_water" : "res://Mod/main/Material/Material_LiquidWater.tres",
		"@material:main:liquid_lava" : "res://Mod/main/Material/Material_LiquidLava.tres",
	}
	self.planets = {
		"@planet:main:earthlike" : "res://Mod/main/Planet/Earthlike/Planet.gd",
	}
	self.planet_handlers = {
	}
	self.batch_objects = {
		"@batch:main:bush" : "res://Mod/main/Model/Bush.tscn",
		"@batch:main:cactus_1" : "res://Mod/main/Model/Cactus1.tscn",
		"@batch:main:cactus_2" : "res://Mod/main/Model/Cactus2.tscn",
		"@batch:main:cactus_3" : "res://Mod/main/Model/Cactus3.tscn",
		"@batch:main:leafy_plant" : "res://Mod/main/Model/LeafyPlant.tscn",
		"@batch:main:lotus" : "res://Mod/main/Model/Lotus.tscn",
		"@batch:main:sea_grass_1" : "res://Mod/main/Model/SeaGrass1.tscn",
		"@batch:main:sea_grass_2" : "res://Mod/main/Model/SeaGrass2.tscn",
		"@batch:main:stone_1" : "res://Mod/main/Model/Stone1.tscn",
		"@batch:main:stone_2" : "res://Mod/main/Model/Stone2.tscn",
		"@batch:main:stone_3" : "res://Mod/main/Model/Stone3.tscn",
		"@batch:main:stone_4" : "res://Mod/main/Model/Stone4.tscn",
		"@batch:main:stone_dirt" : "res://Mod/main/Model/StoneDirt.tscn",
		"@batch:main:stone_snow_1" : "res://Mod/main/Model/StoneSnow1.tscn",
		"@batch:main:stone_snow_2" : "res://Mod/main/Model/StoneSnow2.tscn",
		"@batch:main:stone_snow_3" : "res://Mod/main/Model/StoneSnow3.tscn",
		"@batch:main:tree" : "res://Mod/main/Model/Tree.tscn",
		"@batch:main:tree_snow" : "res://Mod/main/Model/TreeSnow.tscn",
		"@batch:main:wheat" : "res://Mod/main/Model/Wheat.tscn",
	}
	self.elements = {
		"@element:main:resource_liquid_water" : "res://Mod/main/Element/Resource/Liquid/Water.gd",
		"@element:main:resource_liquid_lava" : "res://Mod/main/Element/Resource/Liquid/Lava.gd",
		"@element:main:resource_forest" : "res://Mod/main/Element/Resource/Placement/Forest.gd",
		"@element:main:resource_stone" : "res://Mod/main/Element/Resource/Placement/Stone.gd",
		"@element:main:resource_lotus" : "res://Mod/main/Element/Resource/Placement/Lotus.gd",
		"@element:main:resource_sea_grass" : "res://Mod/main/Element/Resource/Placement/SeaGrass.gd",
		"@element:main:resource_cactus" : "res://Mod/main/Element/Resource/Placement/Cactus.gd",
		"@element:main:resource_wheat" : "res://Mod/main/Element/Resource/Placement/Wheat.gd",
		"@element:main:resource_berry_bush" : "res://Mod/main/Element/Resource/Placement/BerryBush.gd",
		
	}
	self.env_factors = {
		"@env_factor:main:acid" : "res://Mod/main/EnvFactor/Acid.gd",
		"@env_factor:main:cold" : "res://Mod/main/EnvFactor/Cold.gd",
		"@env_factor:main:dry" : "res://Mod/main/EnvFactor/Dry.gd",
		"@env_factor:main:electric" : "res://Mod/main/EnvFactor/Electric.gd",
		"@env_factor:main:forest" : "res://Mod/main/EnvFactor/Forest.gd",
		"@env_factor:main:holy" : "res://Mod/main/EnvFactor/Holy.gd",
		"@env_factor:main:hot" : "res://Mod/main/EnvFactor/Hot.gd",
		"@env_factor:main:magic" : "res://Mod/main/EnvFactor/Magic.gd",
		"@env_factor:main:metal" : "res://Mod/main/EnvFactor/Metal.gd",
		"@env_factor:main:organic" : "res://Mod/main/EnvFactor/Organic.gd",
		"@env_factor:main:rock" : "res://Mod/main/EnvFactor/Rock.gd",
		"@env_factor:main:void" : "res://Mod/main/EnvFactor/Void.gd",
		"@env_factor:main:wet" : "res://Mod/main/EnvFactor/Wet.gd",
	}
