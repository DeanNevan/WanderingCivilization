extends Node

var name_CN = "资源"

var rarity = clamp(1, 1, 10)#稀有度
var expected_settings = {}#{地块 : [资源生成概率, {物质 : [物质生成概率， 物质预期储量]}]}
#此处概率同时造成总储量的不同，资源生成的算法是：概率判定成功，则循环判断直到判定失败，成功几次就叠加几次预期总储量
var random_rate_reserve = 0.1#预期储量的随机率

var standard_reserve_for_sprite = 500#用于展示Sprite

var terrain

var on_surface#是否在地块表层

var is_init_draw_done = false#是否初始化绘制完成
var drawn_sprite_count = 0#已经绘制的精灵个数，用于更新资源图片

var path
var content = {}
var total_reserve#总储量
var sprite_texture = []

onready var Sprites = Node.new() 

func _ready():
	add_child(Sprites)
	pass

func update_total_reserve():
	var total = 0
	for r in content:
		total += content[r]
	total_reserve = total

func init_generate(terrain):
	
	if expected_settings.keys().find(terrain.enum_index) == -1:
		return false
	var settings = expected_settings[terrain.enum_index]
	#print(settings)
	#print(settings.size())
	#for layer_range_count in settings.size():
	#print(settings[layer_range_count])
	#var layer_range = settings[layer_range_count][0]
	var resource_generate_probability = settings[0]
	var substance_list = settings[1]
	#for layer_count in layer_range.size():
	content = {}
	while randf() <= resource_generate_probability:
		for substance in substance_list:
			var substance_generate_probability = substance_list.get(substance)[0]
			var expected_reserve = substance_list.get(substance)[1]
			if randf() <= substance_generate_probability:
				if content.keys().has(substance):
					content[substance] += floor(expected_reserve * rand_range(1 - random_rate_reserve, 1 + random_rate_reserve))
				else:
					content[substance] = floor(expected_reserve * rand_range(1 - random_rate_reserve, 1 + random_rate_reserve))
	terrain.add_resource(self, content)