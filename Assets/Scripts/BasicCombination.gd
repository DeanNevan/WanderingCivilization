extends RigidBody2D

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
	#print(Global.get_position_with_location(Vector2(0, 0)))
	for i in range(0,6):
		for i1 in range(0, 6):
			#print(str(Vector2(i, i1)) + str(Global.get_position_with_location(Vector2(i, i1))))
			#print(5.2 % 2)
			pass

func _process(delta):
	if Input.is_action_pressed("right_mouse_button"):
		update()
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
