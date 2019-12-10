extends Node

var name_CN = "建筑"

var expected_terrains = {Global.TERRAIN.DIRT : 1}#可以建造的地块以及对应的建造期待值（建造难易度）
#var type
var terrain#建筑所处地块
var layer#所处层级
var size = 100#建筑大小

var sprite_texture = []
var sprite_offset = Vector2(0, -10)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
