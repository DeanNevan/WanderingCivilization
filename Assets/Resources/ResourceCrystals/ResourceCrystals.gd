extends "res://Assets/Scripts/BasicResource.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "水晶簇"
	on_surface = true
	rarity = 2
	expected_settings = {
		Global.TERRAIN.SAND : [ 0.15, {Global.SUBSTANCE_CRYSTAL : [1, 20]}], 
		Global.TERRAIN.MARS : [ 0.4, {Global.SUBSTANCE_OAK : [1, 60]}], 
		Global.TERRAIN.STONE : [0.2, {Global.SUBSTANCE_OAK : [1, 30]}]
	}
	random_rate_reserve = 0.1#预期总储量的随机率
	standard_reserve_for_sprite = 80
	#path = "res://Assets/Resources/ResourceForestOak/ResourceForestOak.tscn"
	sprite_texture = [
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/crystals1.png",
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/crystals2.png"
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
