extends "res://Assets/Scripts/BasicResource.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	rarity = 1
	#expected_content = {Global.SUBSTANCE.OAK : [0.95, 1], Global.SUBSTANCE.MAPLE : [0.02, 0.1], Global.SUBSTANCE.ELM : [0.02, 0.1], Global.SUBSTANCE.ROSEWOOD : [0.01, 0.1]}#预期含量比例、生成概率
	expected_settings ={Global.TERRAIN.SAND : [[[surface_layer], 0.6, {Global.SUBSTANCE_CACTUS : [0.8, 120]}]], 
	}
	random_rate_reserve = 0.1#预期总储量的随机率
	standard_reserve_for_sprite = 200
	#path = "res://Assets/Resources/ResourceCactus/ResourceCactus.tscn"
	sprite_texture = ["res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/cactus1.png", 
					"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/cactus2.png", 
					"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/cactus3.png", 
	]
