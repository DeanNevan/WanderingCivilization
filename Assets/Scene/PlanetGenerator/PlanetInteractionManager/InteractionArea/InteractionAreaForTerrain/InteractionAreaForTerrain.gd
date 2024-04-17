extends InteractionArea
class_name InteractionAreaForTerrain

func init():
	super.init()
	assert(is_instance_valid(target))
	assert(target is PlanetTerrain)
	var terrain : PlanetTerrain = target
	var shape : ConvexPolygonShape3D = _CollisionShape3D.shape
	var vertexes : Array = terrain.get_corner_vertexes_via_round(1)
	vertexes.append_array(terrain.get_corner_vertexes_via_round(0))
	shape.points.resize(vertexes.size())
	var points := []
	for v in vertexes:
		points.append(v.pos + v.pos.normalized() * 0.01)
	for v in vertexes:
		points.append(v.pos + v.pos.normalized() * -0.01)
	#for v in vertexes:
	#if terrain.idx == 0:
		#for p in points:
			#print("Vector3%s," % str(p))
	shape.set_points(points)
	#print(shape.points)
	#for v_idx in vertexes.size():
		#shape.points[v_idx] = vertexes[v_idx].pos
		
		
		#_CollisionPolygon3D.polygon[v_idx] = pos_2d
	#look_at_from_position(terrain.get_center(), terrain.polygon.normal.rotated(Vector3.RIGHT, 0.0001))
	pass
