extends RigidBody2D
signal draw_init_done
signal terrain_layers_init_done
var tag
var type

var array_terrains = []

var invader_handle_array = []

func _draw():
	"""for i in get_child_count():
		if get_child_count() == 0:
			break
		var la = get_parent().get_parent().get_node("Label").duplicate()
		get_parent().add_child(la)
		#la.custom_fonts = DynamicFont.new()
		#var dy = DynamicFont.new()
		#dy.font_data = preload("res://Assets/Fonts/三极准柔宋字体.ttf")
		#la.font = dy
		#la.font_size = 25
		la.rect_position = get_child(i).position - Vector2(50, 35)
		la.text = str(get_child(i).location) + "\n" + str(get_child(i).position)
	"""
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("draw_init_done", self, "terrain_layers_init")
	connect("terrain_layers_init_done", self, "resources_init")
	#print(Global.get_position_with_location(Vector2(0, 0)))
	for i in range(0,6):
		for i1 in range(0, 6):
			#print(str(Vector2(i, i1)) + str(Global.get_position_with_location(Vector2(i, i1))))
			#print(5.2 % 2)
			pass

func _process(delta):
	pass

func get_terrain_with_location(location):
	for i in get_child_count():
		if get_child(i).location == location:
			return get_child(i)
	return null

func init(tag):
	match tag:
		0:
			self.add_to_group("player")
			tag = 0
			self.set_collision_layer_bit(0, false)
			self.set_collision_layer_bit(1, true)
			self.set_collision_mask_bit(0, true)
			self.set_collision_mask_bit(1, true)
			self.set_collision_mask_bit(2, true)
			self.set_collision_mask_bit(3, true)
			self.set_collision_mask_bit(4, false)
			self.set_collision_mask_bit(5, true)
		1:
			self.add_to_group("enemy")
			tag = 1
			self.set_collision_layer_bit(0, false)
			self.set_collision_layer_bit(2, true)
			self.set_collision_mask_bit(0, true)
			self.set_collision_mask_bit(1, true)
			self.set_collision_mask_bit(2, true)
			self.set_collision_mask_bit(3, true)
			self.set_collision_mask_bit(4, true)
			self.set_collision_mask_bit(5, false)
		2:
			self.add_to_group("other")
			tag = 2
			self.set_collision_layer_bit(0, true)
			self.set_collision_mask_bit(0, true)
			self.set_collision_mask_bit(1, true)
			self.set_collision_mask_bit(2, true)
			self.set_collision_mask_bit(3, true)
			self.set_collision_mask_bit(4, true)
			self.set_collision_mask_bit(5, true)

###地块组绘制和初始化###
###传入一个地块组和相应的绘制设置，将会绘制并初始化该地块组
###settings：[地块总数， 禁止哪些地块， 生成模式]
func combination_draw_init(combination_draw_settings, terrain_layers_init_settings):
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
				new_terrain.tag = self.tag
				new_terrain.location = location_array[i]
				self.add_child(new_terrain)
				new_terrain.set_position_with_location(new_terrain.location)
				#new_terrain.activate_detect_area()
				#yield(get_tree(), "idle_frame")
			for i in _count:
				#yield(get_tree(), "idle_frame")
				self.get_child(i).update_neighbour_terrains()
				get_child(i).serial_number = i
	yield(get_tree(), "idle_frame")
	for i in get_child_count():
		get_child(i).activate_area(false)
		get_child(i).activate_detect_area(false)
		get_child(clamp(i - 1, 0, i)).DetectShape.disabled = true
	emit_signal("draw_init_done", terrain_layers_init_settings[0], terrain_layers_init_settings[1])

func update_terrains_serial_number():
	for i in get_child_count():
		get_child(i).serial_number = i

###地块的层级生成和初始化
###settings:[指定地块， [层数标准值，层数波动范围，层数生成模式]，[地平面层级标准值，地平面层级波动范围，地平面层级生成模式]，[资源标准值，资源波动范围，资源生成模式]]
func terrain_layers_init(layers_count_settings = [12, 2, Global.LAYERS_COUNT_SETTINGS_MODE.RANDOM], surface_layer_settings = [6, 2, Global.SURFACE_LAYER_SETTINGS_MODE.RANDOM], layers_resources_setting = [clamp(1, 0, 10), 0.2, Global.LAYERS_RESOURCES_SETTINGS_MODE.RANDOM]):
	var layers_count
	var surface_layer
	for terrain_count in self.get_child_count():
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
			self.get_child(terrain_count).Layers.add_child(layer)
			self.get_child(terrain_count).layers.append(layer)
			layer.level = i
		
		###添加地平面所处层###
		self.get_child(terrain_count).surface_layer = surface_layer
	emit_signal("terrain_layers_init_done")

func resources_init():
	for i in get_node("/root/InGame/WorldData/Resources").get_child_count():
		for terrain in self.get_child_count():
			get_node("/root/InGame/WorldData/Resources").get_child(i).init_generate(self.get_child(terrain))
			#yield(get_tree(), "idle_frame")