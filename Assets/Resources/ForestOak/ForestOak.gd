extends "res://Assets/Scripts/BasicResource.gd"

func _ready():
	rarity = 1
	#expected_content = {Global.SUBSTANCE.OAK : [0.95, 1], Global.SUBSTANCE.MAPLE : [0.02, 0.1], Global.SUBSTANCE.ELM : [0.02, 0.1], Global.SUBSTANCE.ROSEWOOD : [0.01, 0.1]}#预期含量比例、生成概率
	expected_settings ={Global.TERRAIN.DIRT : [[[surface_layer], 0.45, {Global.SUBSTANCE_OAK : [1, 300], Global.SUBSTANCE_MAPLE : [0.1, 30], Global.SUBSTANCE_ELM : [0.1, 30], Global.SUBSTANCE_ROSEWOOD : [0.1, 15]}]], 
						Global.TERRAIN.GRASS : [[[surface_layer], 0.8, {Global.SUBSTANCE_OAK : [1, 800], Global.SUBSTANCE_MAPLE : [0.1, 50], Global.SUBSTANCE_ELM : [0.1, 50], Global.SUBSTANCE_ROSEWOOD : [0.1, 25]}]], 
						Global.TERRAIN.STONE : [[[surface_layer], 0.1, {Global.SUBSTANCE_OAK : [1, 5000], Global.SUBSTANCE_MAPLE : [0.05, 5], Global.SUBSTANCE_ELM : [0.05, 5]}]]
	}
	random_rate_reserve = 0.1#预期总储量的随机率
	path = "res://Assets/Resources/ForestOak/ForestOak.tscn"
	sprite_texture = ["res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/treePine_large.png", 
					"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/treePine_small.png", 
					"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/treeRound_large.png", 
					"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/treeRound_small.png",
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

