extends "res://Assets/Scripts/BasicBuilding.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "麦田"
	expected_terrains = {
		Global.TERRAIN.DIRT : 1, 
		Global.TERRAIN.GRASS : 1, 
		Global.TERRAIN.STONE : 0.2,
		Global.TERRAIN.MARS : 0.15,
		Global.TERRAIN.SAND : 0.15
	}
	sprite_texture = [
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/farmland.png"
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
