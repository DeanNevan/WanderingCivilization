extends Node

var name_CN = "建筑"

var expected_terrains = {Global.TERRAIN.DIRT : 1}#可以建造的地块以及对应的建造期待值（建造难易度）
#var type
var terrain#建筑所处地块
var size = 100#建筑大小

var sprite_texture = []
var sprite_offset = Vector2(0, -10)

var build_basic_time = 100#建造基础用时
var materials = {}#所需材料

onready var Sprites = Node.new() 

func _ready():
	add_child(Sprites)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
