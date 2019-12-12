extends Area2D

signal the_last_terrain_draw_done

var name_CN = "地块"

var tag#player0,enemy1,other2
var type#sand,dirt,stone,mars.grass等

var global_index#地块在GLOBAL脚本中的对应枚举

var serial_number = 0#在地块组中的编号

var location = Vector2()

var margin
var invader = [null, null, null, null, null, null]
var invader_display_array = [false, false, false, false, false, false]
var neighbour_terrains = []#与本Terrain接壤的Terrains

var atmosphere_gas = {}#大气层的气体组成
var units_on_self = {}#在此地块的单位(可移动、变化位置的单位)
var geologic_stability = {0:100, 1:100, 2:100, 3:100, 4:100, 5:100, 6:100, 7:100, 8:100, 9:100}#地质稳定性

var neighbour_vector = Vector2()#相邻向量

onready var DetectArea = Area2D.new()
onready var DetectShape = CollisionShape2D.new()
var detected_area_temp = []

var on_mouse = false
var is_selected = false

var MAX_SPACE = 10000#最大空间

var free_space = MAX_SPACE#剩余空间

var expected_proportion

onready var ShortInformation = preload("res://Assets/Terrains/TerrainShortInformation.tscn").instance()
onready var SelectTerrainEffect = preload("res://Assets/SpecialEffects/SelectTerrainEffect/SelectTerrainEffect.tscn").instance()

onready var Resources = Node.new()
var resources_total_reserve = 0
onready var ResourceSprites = Node.new()

onready var Buildings = Node.new()
onready var BuildingSprites = Node.new()
onready var People = Node.new()

func _ready():
	get_node("/root/InGame/World/SmallUI").add_child(ShortInformation)
	ShortInformation.get_node("Label").visible = false
	#ShortInformation.get_node("ColorRect").visible = false
	connect("mouse_entered", self, "_on_mouse_enter_terrain")
	connect("mouse_exited", self, "_on_mouse_exit_terrain")
	add_child(People)
	add_child(SelectTerrainEffect)
	SelectTerrainEffect.visible = false
	SelectTerrainEffect.z_index = 2
	
	add_child(Resources)
	add_child(Buildings)
	
	for i in $Invader.get_child_count():
		$Invader.get_child(i).texture = null
	
	###检测相邻地块###
	self.add_child(DetectArea)
	#DetectArea.connect("area_entered", self, "_on_DetectArea_area_entered")
	DetectShape.shape = CircleShape2D.new()
	DetectShape.shape.radius = 80
	DetectArea.add_child(DetectShape)
	DetectArea.monitoring = true
	DetectArea.monitorable = true
	DetectShape.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(monitorable)
	if on_mouse:
		if Input.is_action_just_pressed("left_mouse_button"):
			is_selected = true
			
	else:
		if Input.is_action_just_pressed("left_mouse_button") and !Input.is_key_pressed(KEY_SHIFT):
			is_selected = false
	if Input.is_action_pressed("left_mouse_button"):
		detect_MouseRegion()
	
	if is_selected:
		show_short_information()
		
	else:
		shutdown_short_information()

func _on_mouse_enter_terrain():
	on_mouse = true
	

func _on_mouse_exit_terrain():
	on_mouse = false

func detect_MouseRegion():
	if $CollisionShape2D.shape.collide(Transform2D(0, self.global_position), MOUSE.MouseRegionShape.shape, Transform2D(0, MOUSE.MouseRegion.global_position)):
		self.is_selected = true
	elif !Input.is_key_pressed(KEY_SHIFT):
		is_selected = false

func show_short_information():
	ShortInformation.get_node("Label").visible = true
	#ShortInformation.get_node("ColorRect").visible = true
	ShortInformation.get_node("Label").text = "地块：" + name_CN + "\n" + "位置：" + str(location)
	ShortInformation.get_node("Label").text += str(free_space)
	ShortInformation.global_position = global_position
	SelectTerrainEffect.texture = margin
	SelectTerrainEffect.get_node("AnimationPlayer").play("select")
	#yield(get_tree(), "idle_frame")
	SelectTerrainEffect.visible = true

func shutdown_short_information():
	SelectTerrainEffect.get_node("AnimationPlayer").stop()
	ShortInformation.get_node("Label").visible = false
	#ShortInformation.get_node("ColorRect").visible = false
	SelectTerrainEffect.visible = false

func set_position_with_location(location):
	self.position = Global.get_position_with_location(location)

func activate_detect_area(active = true):
	DetectArea.monitoring = active
	DetectArea.monitorable = active
	#DetectShape.disabled = active

func activate_area(active = true):
	self.monitorable = active
	monitoring = active
	$CollisionShape2D.disabled = active

func update_neighbour_terrains():
	activate_detect_area(true)
	yield(get_tree(), "idle_frame")
	neighbour_terrains = []
	var arr = DetectArea.get_overlapping_areas()
	#yield(get_tree(), "idle_frame")
	#arr = DetectArea.get_overlapping_areas()
	for i in arr.size():
		if arr[i].has_method("update_neighbour_terrains"):
			if neighbour_terrains.find(arr[i]) == -1 and arr[i] != self:
				
				neighbour_terrains.append(arr[i])
	#print(neighbour_terrains)
	neighbour_vector = Global.judge_neighbour_vector(location)
	self.update_invader()

func update_invader():
	for i in neighbour_terrains.size():
		var del = neighbour_terrains[i].location - location
		#print("del", del)
		if del == neighbour_vector[0]:
			invader[0] = neighbour_terrains[i].margin
			invader_display_array[0] = !neighbour_terrains[i].invader_display_array[3]
		if del == neighbour_vector[1]:
			invader[1] = neighbour_terrains[i].margin
			invader_display_array[1] = !neighbour_terrains[i].invader_display_array[4]
		if del == neighbour_vector[2]:
			invader[2] = neighbour_terrains[i].margin
			invader_display_array[2] = !neighbour_terrains[i].invader_display_array[5]
		if del == neighbour_vector[3]:
			invader[3] = neighbour_terrains[i].margin
			invader_display_array[3] = !neighbour_terrains[i].invader_display_array[0]
		if del == neighbour_vector[4]:
			invader[4] = neighbour_terrains[i].margin
			invader_display_array[4] = !neighbour_terrains[i].invader_display_array[1]
		if del == neighbour_vector[5]:
			invader[5] = neighbour_terrains[i].margin
			invader_display_array[5] = !neighbour_terrains[i].invader_display_array[2]
	for i in invader_display_array.size():
		if invader_display_array[i]:
			$Invader.get_child(i).texture = invader[i]
		else:
			$Invader.get_child(i).texture = null
	#if location == Vector2():
		#print(invader_display_array)
		#for i in neighbour_terrains.size():
			#print(i)
			#print(neighbour_terrains[i].invader_display_array)

func update_space():
	var total = 0
	for r in Resources.get_child_count():
		Resources.get_child(r).update_total_reserve()
		total += Resources.get_child(r).total_reserve
	for b in Buildings.get_child_count():
		total += Buildings.get_child(b).size
	free_space = MAX_SPACE - total

###更新建筑效果###
func update_building_effect():
	pass

func add_resource(_resource, resource_content):
	var total = 0
	for i in resource_content:
		total += resource_content[i]
	if total > MAX_SPACE - resources_total_reserve:
		return false
	var resource = _resource.duplicate()
	resource.total_reserve = total
	resource.content = resource_content
	Resources.add_child(resource)
	update_space()
	resource.terrain = self
	update_resource_sprites(resource)
	pass

func update_resource_sprites(resource):
	var sprite_count = ceil(resource.total_reserve / resource.standard_reserve_for_sprite)
	if resource.is_init_draw_done:
		var _del = sprite_count - resource.drawn_sprite_count
		if _del == 0:
			return
		elif _del < 0:
			for i in abs(_del):
				resource.Sprites.get_child(randi() % resource.Sprites.get_child_count()).queue_free()
		else:
			for i in _del:
				var sprite = Sprite.new()
				resource.Sprites.add_child()
				sprite.visible = true
				sprite.z_index = 2
				sprite.scale = Vector2(0.65, 0.65)
				sprite.offset = Vector2(0, -10)
				resource.Sprites.add_child(sprite)
				sprite.texture = load(resource.sprite_texture[randi() % resource.sprite_texture.size()])
				sprite.position = position + Vector2((randi() % 85) - 42, (randi() % 85) - 42)
		return
	
	resource.is_init_draw_done = true
	resource.drawn_sprite_count = sprite_count
	for i in sprite_count:
		var sprite = Sprite.new()
		sprite.visible = true
		sprite.z_index = 2
		sprite.scale = Vector2(0.65, 0.65)
		sprite.offset = Vector2(0, -10)
		resource.Sprites.add_child(sprite)
		sprite.texture = load(resource.sprite_texture[randi() % resource.sprite_texture.size()])
		sprite.position = position + Vector2((randi() % 85) - 42, (randi() % 85) - 42)

func add_building(_building):
	if _building.size > free_space:
		return false
	var building = _building.duplicate()
	Buildings.add_child(building)
	
	update_space()
	building.terrain = self
	update_building_effect()
	var sprite = Sprite.new()
	building.Sprites.add_child(sprite)
	sprite.texture = load(building.sprite_texture[randi() % building.sprite_texture.size()])
	sprite.offset = building.sprite_offset
	sprite.scale = Vector2(0.45, 0.45)
	sprite.z_index = 1
	sprite.visible = true
	sprite.position = position + Vector2((randi() % 85) - 42, (randi() % 85) - 42)
