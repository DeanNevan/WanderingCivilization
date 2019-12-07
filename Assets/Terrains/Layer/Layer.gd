extends Node

var MAX_SPACE = 10000#最大空间

var free_space = 0#剩余空间

var expected_proportion

var level

onready var terrain = get_parent().get_parent()

var origin_people_capacity = 50
var people_capacity = origin_people_capacity#人口容纳能力

onready var Resources = Node.new()
var resources_total_reserve = 0
onready var ResourceSprites = Node.new()

onready var Buildings = Node.new()
onready var BuildingSprites = Node.new()

func _ready():
	add_child(Resources)
	add_child(ResourceSprites)
	add_child(Buildings)
	add_child(BuildingSprites)

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
	people_capacity = origin_people_capacity
	for b in Buildings.get_child_count():
		people_capacity += Buildings.get_child(b).people_capacity

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
	resource.terrain = terrain
	resource.layer = self
	update_resource_sprites()
	pass

func update_resource_sprites():
	for i in ResourceSprites.get_child_count():
		ResourceSprites.get_child(i).queue_free()
	for resource in Resources.get_child_count():
		var sprite_count = ceil(Resources.get_child(resource).total_reserve / Resources.get_child(resource).standard_reserve_for_sprite)
		for i in sprite_count:
			var sprite = Sprite.new()
			sprite.visible = true
			sprite.z_index = 2
			sprite.scale = Vector2(0.65, 0.65)
			sprite.offset = Vector2(0, -10)
			ResourceSprites.add_child(sprite)
			sprite.texture = load(Resources.get_child(resource).sprite_texture[randi() % Resources.get_child(resource).sprite_texture.size()])
			sprite.position = terrain.position + Vector2((randi() % 85) - 42, (randi() % 85) - 42)

func add_building(_building):
	if _building.size > free_space:
		return false
	var building = _building.duplicate()
	Buildings.add_child(building)
	
	update_space()
	building.terrain = terrain
	building.layer = self
	update_building_effect()
	var sprite = Sprite.new()
	BuildingSprites.add_child(sprite)
	sprite.texture = load(building.sprite_texture[randi() % building.sprite_texture.size()])
	sprite.offset = building.sprite_offset
	sprite.scale = Vector2(0.45, 0.45)
	sprite.z_index = 1
	sprite.visible = true
	sprite.position = terrain.position + Vector2((randi() % 85) - 42, (randi() % 85) - 42)