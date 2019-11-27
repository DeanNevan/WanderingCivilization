extends RigidBody2D

var tag
var type

var arr_hexagons = []
var dic_hexagons_location = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Global.get_position_with_location(Vector2(1, 1)))
	for i in range(2,6):
		for i1 in range(2, 6):
			print(Global.get_position_with_location(Vector2(i, i1)))
			#print(5.2 % 2)
			pass
	

func add_hexagon(target, location):
	pass

func get_hexagon_with_location(location):
	var hexagon_in_the_location = dic_hexagons_location[location]
	if hexagon_in_the_location != null:
		return hexagon_in_the_location

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
