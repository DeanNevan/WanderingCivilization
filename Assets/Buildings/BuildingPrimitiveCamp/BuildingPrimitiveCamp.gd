extends "res://Assets/Scripts/BasicBuilding.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	expected_terrains = {
		Global.TERRAIN.DIRT : 1, 
		Global.TERRAIN.GRASS : 1, 
		Global.TERRAIN.STONE : 0.9,
		Global.TERRAIN.MARS : 0.8,
		Global.TERRAIN.SAND : 0.65
	}
	sprite_texture = [
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/indianTent_back.png",
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/indianTent_front.png"
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
