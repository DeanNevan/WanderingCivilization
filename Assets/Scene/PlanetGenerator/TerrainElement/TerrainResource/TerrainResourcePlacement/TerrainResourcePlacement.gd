extends TerrainResource
class_name TerrainResourcePlacement

var RANDOM_OFFSET_RADIUS_RATE := 0.7

var Scene_Instance : PackedScene
@export var remain_percent_to_instance_count := {
	Vector2(0, 20) : 1,
	Vector2(20, 40) : 2,
	Vector2(40, 60) : 3,
	Vector2(60, 80) : 4,
	Vector2(80, 100) : 5,
}
@export var scale_range := Vector2(0.5, 1.0)
@export var yaw_range := Vector2(0, 360)
@export var pitch_range := Vector2(0, 0)
@export var roll_range := Vector2(0, 0)
@export var height_offset_range := Vector2(-0.1, 0.1) # 该数值将乘以星球的HEIGHT_EACH_LEVEL作为最终的高度偏移量范围

var instance_count := 0
var instances := []

var faces := []

func _init():
	super._init()

func init_display():
	super.init_display()
	var range := Vector2i()
	range.x = terrain.get_faces_range_via_round(1).x
	range.y = terrain.get_faces_range_via_round(2).y
	for i in range(range.x, range.y + 1, 1):
		faces.append(i)
	faces.shuffle()
	update_instance_count()

func random_instance_placement(instance : Node3D, idx : int):
	var scale_r := terrain.planet.rander_for_generation.randf_range(scale_range.x, scale_range.y)
	instance.scale *= Vector3(scale_r, scale_r, scale_r)
	instance.rotate_object_local(Vector3.UP, terrain.planet.rander_for_generation.randf_range(deg_to_rad(yaw_range.x), deg_to_rad(yaw_range.y)))
	instance.rotate_object_local(Vector3.RIGHT, terrain.planet.rander_for_generation.randf_range(deg_to_rad(pitch_range.x), deg_to_rad(pitch_range.y)))
	instance.rotate_object_local(Vector3.BACK, terrain.planet.rander_for_generation.randf_range(deg_to_rad(roll_range.x), deg_to_rad(roll_range.y)))
	var pos_r : float = terrain.planet.rander_for_generation.randf_range(height_offset_range.x, height_offset_range.y) * terrain.planet.HEIGHT_EACH_LEVEL
	instance.position = instance.position.normalized() * (pos_r + instance.position.length())
	
	pass

func init_instance_position(instance : Node3D, idx : int):
	var face_idx : int = faces[idx % faces.size()]
	var pos := Vector3()
	var normal := Vector3.UP
	pos = terrain.random_pick_pos_around_face(face_idx)
	if on_liquid_surface and terrain.has_liquid():
		pos = terrain.liquid.liquid_area.cal_pos_via_height_level(pos)
		var vec : Vector3i = terrain.faces_idx[face_idx]
		var p1 : Vector3 = terrain.vertexes[vec.x].pos
		var p2 : Vector3 = terrain.vertexes[vec.y].pos
		var p3 : Vector3 = terrain.vertexes[vec.z].pos
		p1 = terrain.liquid.liquid_area.cal_pos_via_height_level(p1)
		p2 = terrain.liquid.liquid_area.cal_pos_via_height_level(p2)
		p3 = terrain.liquid.liquid_area.cal_pos_via_height_level(p3)
		normal = Math.get_normal_via_triangle(p1, p2, p3)
	else:
		normal = terrain.get_face_normal(face_idx)
	instance.look_at_from_position(pos, pos + normal.rotated(Vector3.RIGHT, 0.0001))
	instance.rotate_object_local(Vector3.RIGHT, - PI / 2)
	pass

func new_instance(instance : Node):
	add_child(instance)
	instances.append(instance)
	init_instance_position(instance, instances.size() - 1)
	random_instance_placement(instance, instances.size() - 1)

func remove_instance():
	var instance = instances.back()
	instances.pop_back()
	if instance.has_method("delete"):
		instance.delete()
	else:
		instance.queue_free()

func update_instances():
	if instances.size() == instance_count:
		return
	elif instances.size() < instance_count:
		for i in instance_count - instances.size():
			new_instance(null)
	else:
		for i in instances.size() - instance_count:
			remove_instance()

func update_instance_count():
	var percent : float = float(health) / max_health * 100.0
	for r in remain_percent_to_instance_count:
		if r.x <= percent and r.y >= percent:
			instance_count = remain_percent_to_instance_count[r]
			break
	update_instances()

func _on_self_health_changed(_resource):
	super._on_self_health_changed(_resource)
	update_instance_count()
	pass
