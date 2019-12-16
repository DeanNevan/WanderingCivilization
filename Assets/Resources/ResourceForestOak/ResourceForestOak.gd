extends "res://Assets/Scripts/BasicResource.gd"

func _ready():
	name_CN = "橡树林"
	on_surface = true
	rarity = 1
	#expected_content = {Global.SUBSTANCE.OAK : [0.95, 1], Global.SUBSTANCE.MAPLE : [0.02, 0.1], Global.SUBSTANCE.ELM : [0.02, 0.1], Global.SUBSTANCE.ROSEWOOD : [0.01, 0.1]}#预期含量比例、生成概率
	expected_settings = {
		Global.TERRAIN.DIRT : [ 0.45, {Global.SUBSTANCE_OAK : [1, 200], Global.SUBSTANCE_MAPLE : [0.2, 20], Global.SUBSTANCE_ELM : [0.2, 20], Global.SUBSTANCE_ROSEWOOD : [0.15, 10]}], 
		Global.TERRAIN.GRASS : [ 0.8, {Global.SUBSTANCE_OAK : [1, 400], Global.SUBSTANCE_MAPLE : [0.2, 30], Global.SUBSTANCE_ELM : [0.2, 30], Global.SUBSTANCE_ROSEWOOD : [0.15, 20]}], 
		Global.TERRAIN.STONE : [0.1, {Global.SUBSTANCE_OAK : [1, 50], Global.SUBSTANCE_MAPLE : [0.1, 10], Global.SUBSTANCE_ELM : [0.1, 10]}]
	}
	random_rate_reserve = 0.1#预期总储量的随机率
	standard_reserve_for_sprite = 600
	#path = "res://Assets/Resources/ResourceForestOak/ResourceForestOak.tscn"
	sprite_texture = [
		#"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/treePine_large.png", 
		#"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/treePine_small.png", 
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/treeRound_large.png", 
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/treeRound_small.png",
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

