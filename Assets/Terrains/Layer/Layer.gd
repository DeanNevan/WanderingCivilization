extends Node

var units_on_layer = {}
var manmades_on_layer = {}
var resources_on_layer = {}

var expected_proportion

var level

onready var terrain = get_parent().get_parent()

var type#under = 0，sky = 1

onready var Resources = Node.new()

onready var ResourceSprites = Node.new()

func _ready():
	add_child(Resources)
	add_child(ResourceSprites)

func add_resource(resource_path, resource_content):
	var resource = load(resource_path).instance()
	resource.content = resource_content
	Resources.add_child(resource)
	resource.terrain = terrain
	resource.layer = self
	var total = 0
	for i in resource_content:
		total += resource_content[i]
	resource.total_reserve = total
	#print(resource_content)
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
			sprite.offset = Vector2(0, -10)
			ResourceSprites.add_child(sprite)
			sprite.texture = load(Resources.get_child(resource).sprite_texture[randi() % Resources.get_child(resource).sprite_texture.size()])
			sprite.position = terrain.position + Vector2((randi() % 91) - 45, (randi() % 91) - 45)