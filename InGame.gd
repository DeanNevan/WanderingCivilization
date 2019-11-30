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
	_gamedata_init()
	#yield(self, "_gamedata_init_done")
	_player_init()

###游戏信息初始化###
func _gamedata_init(element_settings = [[30, 0.1, 1, Global.ELEMENT_INIT_SETTINGS_MODE.AVERAGE]], addition_settings = [[], [], [], []]):
	_element_init(element_settings[0])
	#yield(self, "_element_init_done")
	emit_signal("_gamedata_init_done")

###世界元素初始化###
#element_init_settings中的第一个元素表示元素数量，第二个是随机范围，第三个是倍率，第四个是模式
func _element_init(element_init_settings):
	var _count = element_init_settings[0]
	var _range = element_init_settings[1]
	var _times = element_init_settings[2]
	var _mode = element_init_settings[3]
	
	var element = []
	var last_array = []
	for x in _count:
		var para = []
		match _mode:
			Global.ELEMENT_INIT_SETTINGS_MODE.AVERAGE:
				var melting_point = 0
				for y in 14:
					var temp_para
					if y == 7:#密度
						temp_para = (x + 1) * (1 + rand_range(- _range, _range))
					elif y == 10:#熔点
						melting_point = (x + 1) * 10 * (1 + rand_range(- _range, _range))
						temp_para = (x + 1) * 10 * (1 + rand_range(- _range, _range))
					elif y == 11:#沸点
						temp_para = melting_point * 2 * (1 + rand_range(- _range, _range))
					else:
						temp_para = (x + 1) * 10 * (1 + rand_range(- _range, _range))
					para.append(temp_para)
			Global.ELEMENT_INIT_SETTINGS_MODE.RANDOM:
				var melting_point = 0
				for y in 14:
					var temp_para
					if y == 7:
						temp_para = randi() % (_count * 10) + 1
					elif y == 10:
						melting_point = randi() % (_count * 100) + 1
						temp_para = randi() % (_count * 100) + 1
					elif y == 11:
						temp_para = floor(rand_range(melting_point, _count * 100))
					else:
						temp_para = randi() % (_count * 100) + 1
					para.append(temp_para)
		var new_element = Node.new()
		$WorldData/Element.add_child(new_element)
		new_element.script = preload("res://Assets/Scripts/BasicMaterial.gd")
		new_element.standard_para = para
		#print(str(x) + str(new_element.standard_para))
	emit_signal("_element_init_done")

###玩家初始化###
func _player_init(player_combination_draw_settings = [100, [], Global.COMBINATION_DRAW_SETTINGS_MODE.RANDOM]):
	combination_draw_init(player_combination, player_combination_draw_settings)
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
				var new_terrain = Global.TERRAINS[randi() % (Global.TERRAINS.size() - 1)].instance()
				new_terrain.tag = combination.tag
				new_terrain.location = location_array[i]
				combination.add_child(new_terrain)
				new_terrain.set_position_with_location(new_terrain.location)
				new_terrain.activate_detect_area()
				#yield(get_tree(), "idle_frame")
			for i in _count:
				yield(get_tree(), "idle_frame")
				combination.get_child(i).update_neighbour_terrains()

###地块组的层级生成和初始化
###settings:[层数标准值，层数波动范围，层数生成模式，地平面层级标准值，地平面层级波动范围，地平面层级生成模式，资源标准值，资源波动范围，资源生成模式]
func combination_layers_init(layers_count_standard = 12, layers_count_standard_range = 2, layers_count_settings = [], surface_standard = 6, surface_standard_range = 2, surface_settings = [], resources_standard = clamp(1, 0, 10), resources_standard_range = 0.2, resources_setting = []):
	pass