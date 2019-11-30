extends Area2D
#一个地块初始拥有10个单位的地下深度，10个单位的大气高度，地表单独计算

var tag#player0,enemy1,other2
var type#sand,dirt,stone,mars.grass等

var location = Vector2()

var mass = 10000#质量
var depth = 10

var margin
var invader = [null, null, null, null, null, null]
var invader_display_array = [false, false, false, false, false, false]
var neighbour_terrains = []#与本Terrain接壤的Terrains

var atmosphere_gas = {}#大气层的气体组成
var units_on_self = {}#在此地块的单位(可移动、变化位置的单位)
var geologic_stability = {0:100, 1:100, 2:100, 3:100, 4:100, 5:100, 6:100, 7:100, 8:100, 9:100}#地质稳定性

var neighbour_vector = Vector2()#相邻向量

onready var detect_area = Area2D.new()
onready var detect_shape = CollisionShape2D.new()
var detected_area_temp = []

onready var Layers = Node.new()


func _ready():
	
	add_child(Layers)
	
	for i in $Invader.get_child_count():
		$Invader.get_child(i).texture = null
	
	###检测相邻地块###
	self.add_child(detect_area)
	#detect_area.connect("area_entered", self, "_on_detect_area_area_entered")
	detect_shape.shape = CircleShape2D.new()
	detect_shape.shape.radius = 80
	detect_area.add_child(detect_shape)
	detect_area.monitoring = true
	detect_area.monitorable = true
	#detect_shape.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if location == Vector2():
		#print(neighbour_terrains.size())
	pass
	#print(neighbour_terrains)

func set_position_with_location(location):
	self.position = Global.get_position_with_location(location)

func activate_detect_area(active = true):
	detect_area.monitoring = active
	detect_area.monitorable = active
	#detect_shape.disabled = active

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

func update_neighbour_terrains():
	neighbour_terrains = []
	var arr = detect_area.get_overlapping_areas()
	yield(get_tree(), "idle_frame")
	#arr = detect_area.get_overlapping_areas()
	for i in arr.size():
		if arr[i].has_method("update_neighbour_terrains"):
			if neighbour_terrains.find(arr[i]) == -1 and arr[i] != self:
				
				neighbour_terrains.append(arr[i])
	#print(neighbour_terrains)
	neighbour_vector = Global.judge_neighbour_vector(location)
	self.update_invader()