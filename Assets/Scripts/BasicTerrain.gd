extends Area2D
#一个地块初始拥有10个单位的地下深度，10个单位的大气高度，地表单独计算

var tag#player0,enemy1,other2
var type#sand,dirt,stone,mars.grass等

var mass = 10000#质量
var depth = 10
var location

var margin
var invader = {0 : null, 1 : null, 2 : null, 3 : null, 4 : null, 5 : null}
var neighbour_terrains = []#与本Terrain接壤的Terrains

var surface_resources = []#地表资源
var surface_artifact = []#地表人造建筑
var surface_pollution = {}#地表污染
var underground_resources = []#地下资源
var underground_artifact = []#地下人造建筑
var undergroud_pollution = {}#地下污染
var atmosphere_resources = []#大气资源
var atmosphere_artifact = []#大气人造建筑
var atmosphere_pollution = {}#大气污染

var atmosphere_gas = {}#大气层的气体组成
var units_on_self = {}#在此地块的单位(可移动、变化位置的单位)
var geologic_stability = {0:100, 1:100, 2:100, 3:100, 4:100, 5:100, 6:100, 7:100, 8:100, 9:100}#地质稳定性

onready var detect_area = Area2D.new()


func _ready():
	###检测相邻地块###
	self.add_child(detect_area)
	detect_area.connect("area_entered", self, "_on_detect_area_area_entered")
	var detect_shape = CollisionShape2D.new()
	detect_shape.shape = CircleShape2D.new()
	detect_shape.shape.radius = 80
	detect_area.add_child(detect_shape)
	detect_area.monitoring = false
	detect_area.monitorable = false
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_detect_area_area_entered(area):
	print(area.tag)
	var new = []
	if area.tag == self.tag and area != self:
		new.append(area)
	update_neighbour_terrains(new)

func activate_detect_area(active = true):
	if active:
		detect_area.monitoring = true
	else:
		detect_area.monitoring = false

func update_invader():
	for i in invader.keys():
		$Invader.get_child(i).texture = invader[i]

func update_neighbour_terrains(new = neighbour_terrains):
	neighbour_terrains.clear()
	neighbour_terrains = new
	for i in 5:
		$Invader.get_child(i).texture = null
	for i in neighbour_terrains:
		if neighbour_terrains[i].type != self.type:
			#该相邻地块在右上方0号，自己在对方左下方3号
			if neighbour_terrains[i].position.y < self.position.y and neighbour_terrains[i].position.x > self.position.x:
				neighbour_terrains[i].invader[3] = self.margin
			#该相邻地块在右方1号，自己在对方左方4号
			if abs(neighbour_terrains[i].position.y - self.position.y) < 1 and neighbour_terrains[i].position.x > self.position.x:
				neighbour_terrains[i].invader[4] = self.margin
			#该相邻地块在右下方2号，自己在对方左上方5号
			if neighbour_terrains[i].position.y > self.position.y and neighbour_terrains[i].position.x > self.position.x:
				neighbour_terrains[i].invader[5] = self.margin
			#该相邻地块在左下方3号，自己在对方右上方0号
			if neighbour_terrains[i].position.y > self.position.y and neighbour_terrains[i].position.x < self.position.x:
				neighbour_terrains[i].invader[0] = self.margin
			#该相邻地块在左方4号，自己在对方右方1号
			if abs(neighbour_terrains[i].position.y - self.position.y) < 1 and neighbour_terrains[i].position.x < self.position.x:
				neighbour_terrains[i].invader[1] = self.margin
			#该相邻地块在左上方5号，自己在对方右下方2号
			if neighbour_terrains[i].position.y > self.position.y and neighbour_terrains[i].position.x < self.position.x:
				neighbour_terrains[i].invader[2] = self.margin
		neighbour_terrains[i].update_invader()