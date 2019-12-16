extends "res://Assets/Scripts/BasicTerrain.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "石地块"
	margin = preload("res://Assets/Art/Hexagons-pack/BasicPack/PNG/Tiles/Terrain/Stone/stone_01.png")
	enum_index = Global.TERRAIN.STONE

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
