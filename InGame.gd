extends Node

signal _gamedata_init_done
signal _element_init_done
signal _player_combination_init_done
signal _player_resources_init_done
signal _player_init_done

onready var player_combination = $World/Player/PlayerCombination


var times = 0
var Times = 0

func _ready():
	randomize()
	_game_init()
	

func _process(delta):
	pass

###游戏初始化###
func _game_init():
	_player_init()
	


###玩家初始化###
func _player_init(player_combination_draw_settings = [100, [], Global.COMBINATION_DRAW_SETTINGS_MODE.RANDOM], player_terrain_layers_init_settings = [[15, 2, Global.LAYERS_COUNT_SETTINGS_MODE.RANDOM], [9, 2, Global.SURFACE_LAYER_SETTINGS_MODE.RANDOM]]):
	combination_draw_init(player_combination, player_combination_draw_settings)
	yield(get_tree(), "idle_frame")
	terrain_layers_init(player_combination, player_terrain_layers_init_settings[0], player_terrain_layers_init_settings[1])
	yield(get_tree(), "idle_frame")
	resources_init(player_combination)
	pass


###地块组绘制和初始化###
###传入一个地块组和相应的绘制设置，将会绘制并初始化该地块组
###settings：[地块总数， 禁止哪些地块， 生成模式]
func combination_draw_init(combination, combination_draw_settings):
	var _count = combination_draw_settings[0]
	var _ban = combination_draw_settings[1]
	var _mode = combination_draw_settings[2]
	
	match _mode:
		Global.COMBINATION_DRAW_SETTINGS_MODE.RANDOM:
			var location_array = []
			var i = -1
			while true:
				var loc_arr = location_array
				#Times += 1
				i += 1
				#print("i", i)
				#print(location_array.size())
				#if i != location_array.size():
					#i = i - 1
					#print("i", i)
				if i == 0:
					location_array.append(Vector2())
					continue
				
				#print("the " + str(i + 1))
				#print("loc" + str(location_array))
				
				while true:
					#yield(get_tree(), "idle_frame")
					var jud = false
					loc_arr.shuffle()
					var ran_loc = loc_arr[0]
					var arr
					#print("pick loc", str(ran_loc))
					if ran_loc.y == 0:
						arr = [Vector2(1, -1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 1), Vector2(-1, 0), Vector2(0, -1)]
					elif (ran_loc.y < 0 and fmod(abs(ran_loc.y), 2) == 1) or (ran_loc.y > 0 and fmod(abs(ran_loc.y), 2) == 0):
						arr = [Vector2(-1, -1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 1), Vector2(-1, 0), Vector2(0, -1)]
					else:
						arr = [Vector2(1, -1), Vector2(1, 0), Vector2(0, -1), Vector2(1, 1), Vector2(-1, 0), Vector2(0, -1)]
					while true:
						var del
						arr.shuffle()
						del = arr[0]
						if location_array.find(ran_loc + del) == -1:
							#print("1")
							jud = true
							location_array.append(ran_loc + del)
							#print("the " + str(i + 1) + " " + str(ran_loc + del))
							break
						else:
							#print("2")
							arr.erase(del)
							if arr.size() == 0:
								jud = false
								break
					if jud:
						#print("size", location_array.size())
						#print("-------")
						break
					else:
						
						#print("ano one")
						loc_arr.erase(ran_loc)
						if location_array.find(ran_loc) == -1:
							location_array.append(ran_loc)
						#if location_array.size() == 0:
							#print("nmsl")
				if location_array.size() == _count:
					break
			for i in _count:
				var new_terrain = Global.TERRAINS[randi() % (Global.TERRAINS.size())].instance()
				new_terrain.tag = combination.tag
				new_terrain.location = location_array[i]
				combination.add_child(new_terrain)
				new_terrain.set_position_with_location(new_terrain.location)
				new_terrain.activate_detect_area()
				#yield(get_tree(), "idle_frame")
			for i in _count:
				yield(get_tree(), "idle_frame")
				combination.get_child(i).update_neighbour_terrains()

###地块的层级生成和初始化
###settings:[指定地块， [层数标准值，层数波动范围，层数生成模式]，[地平面层级标准值，地平面层级波动范围，地平面层级生成模式]，[资源标准值，资源波动范围，资源生成模式]]
func terrain_layers_init(combination, layers_count_settings = [12, 2, Global.LAYERS_COUNT_SETTINGS_MODE.RANDOM], surface_layer_settings = [6, 2, Global.SURFACE_LAYER_SETTINGS_MODE.RANDOM], layers_resources_setting = [clamp(1, 0, 10), 0.2, Global.LAYERS_RESOURCES_SETTINGS_MODE.RANDOM]):
	var layers_count
	var surface_layer
	for terrain_count in combination.get_child_count():
		match layers_count_settings[2]:
			Global.LAYERS_COUNT_SETTINGS_MODE.RANDOM:
				layers_count = layers_count_settings[0] + (randi() % (layers_count_settings[1] * 2) + 1) - layers_count_settings[1]
		
		match surface_layer_settings[2]:
			Global.SURFACE_LAYER_SETTINGS_MODE.RANDOM:
				surface_layer = surface_layer_settings[0] + (randi() % (surface_layer_settings[1] * 2) + 1) - surface_layer_settings[1]
		
		###添加层###
		for i in layers_count:
			var layer = Global.LAYER.instance()
			#print(layers_count)
			combination.get_child(terrain_count).Layers.add_child(layer)
			combination.get_child(terrain_count).layers.append(layer)
			layer.level = i
		
		###添加地平面所处层###
		combination.get_child(terrain_count).surface_layer = surface_layer


func resources_init(combination):
	for i in $WorldData/Resources.get_child_count():
		for terrain in combination.get_child_count():
			$WorldData/Resources.get_child(i).init_generate(combination.get_child(terrain))