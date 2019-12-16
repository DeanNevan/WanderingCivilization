extends "res://Assets/Scripts/BasicResource.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "岩石"
	on_surface = true
	rarity = 1
	#expected_content = {Global.SUBSTANCE.OAK : [0.95, 1], Global.SUBSTANCE.MAPLE : [0.02, 0.1], Global.SUBSTANCE.ELM : [0.02, 0.1], Global.SUBSTANCE.ROSEWOOD : [0.01, 0.1]}#预期含量比例、生成概率
	expected_settings = {
		Global.TERRAIN.DIRT : [ 0.35, {Global.SUBSTANCE_STONE : [1, 35], Global.SUBSTANCE_COPPER_ORE : [0.15, 15], Global.SUBSTANCE_TIN_ORE : [0.1, 10], Global.SUBSTANCE_LEAD_ORE : [0.1, 10]}], 
		Global.TERRAIN.GRASS : [ 0.25, {Global.SUBSTANCE_STONE : [1, 30], Global.SUBSTANCE_COPPER_ORE : [0.15, 15], Global.SUBSTANCE_TIN_ORE : [0.1, 10], Global.SUBSTANCE_LEAD_ORE : [0.1, 10]}], 
		Global.TERRAIN.STONE : [0.8, {Global.SUBSTANCE_STONE : [1, 80], Global.SUBSTANCE_COPPER_ORE : [0.25, 25], Global.SUBSTANCE_TIN_ORE : [0.2, 20], Global.SUBSTANCE_LEAD_ORE : [0.2, 20]}],
		Global.TERRAIN.SAND : [0.3, {Global.SUBSTANCE_STONE : [1, 30], Global.SUBSTANCE_COPPER_ORE : [0.3, 25], Global.SUBSTANCE_TIN_ORE : [0.3, 25], Global.SUBSTANCE_LEAD_ORE : [0.3, 25]}]
	}
	random_rate_reserve = 0.1#预期总储量的随机率
	standard_reserve_for_sprite = 300
	#path = "res://Assets/Resources/ResourceForestOak/ResourceForestOak.tscn"
	sprite_texture = [
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/rockGrey_small1.png",
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/rockGrey_small2.png",
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/rockGrey_small3.png",
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/rockGrey_small4.png",
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/rockGrey_small5.png",
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/rockGrey_small6.png",
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/rockGrey_small7.png",
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
