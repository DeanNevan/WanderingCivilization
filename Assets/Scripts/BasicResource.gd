extends Node

var rarity = clamp(1, 1, 10)#稀有度
var expected_settings = {}#{地块 : [[[层], 资源生成概率, {物质 : [物质生成概率， 物质预期储量]}]]}
#此处概率同时造成总储量的不同，资源生成的算法是：概率判定成功，则循环判断直到判定失败，成功几次就叠加几次预期总储量
var random_rate_reserve = 0.1#预期储量的随机率

var standard_reserve_for_sprite = 500#用于展示Sprite

var terrain
var surface_layer = 0#地块表面层级
var layers_count = 0#地块总层数

var path
var layer
var content = {}
var total_reserve#总储量
var sprite_texture = []


func _ready():
	pass # Replace with function body.

func init_generate(terrain):
	if expected_settings.keys().find(terrain.global_index) == -1:
		return false
	surface_layer = terrain.surface_layer
	#print(surface_layer)
	layers_count = terrain.layers.size()
	var settings = expected_settings[terrain.global_index]
	#print(settings)
	#print(settings.size())
	for layer_range_count in settings.size():
		#print(settings[layer_range_count])
		var layer_range = settings[layer_range_count][0]
		var resource_generate_probability = settings[layer_range_count][1]
		var substance_list = settings[layer_range_count][2]
		for layer_count in layer_range.size():
			content = {}
			var real_layer = surface_layer + layer_range[layer_count]
			if real_layer < 0:
				continue
			while randf() <= resource_generate_probability:
				for substance in substance_list:
					var substance_generate_probability = substance_list.get(substance)[0]
					var expected_reserve = substance_list.get(substance)[1]
					if randf() <= substance_generate_probability:
						if content.keys().has(substance):
							content[substance] += expected_reserve * rand_range(1 - random_rate_reserve, 1 + random_rate_reserve)
						else:
							content[substance] = expected_reserve * rand_range(1 - random_rate_reserve, 1 + random_rate_reserve)
			terrain.layers[real_layer].add_resource(path, content)