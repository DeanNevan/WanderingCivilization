extends "res://Assets/Scripts/BasicBuilding.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	#sprite_offset = Vector2()
	size = 40
	people_capacity = 10
	sprite_texture = [
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/indianTent_back.png",
		"res://Assets/Art/Hexagons-pack/BasicPack/PNG/Objects/indianTent_front.png"
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
