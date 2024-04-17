extends Node3D
func _ready():
	var mdt : MeshDataTool = $TerrainFocusMarker.mdt
	var points := {}
	for i in mdt.get_vertex_count():
		var point_pos : Vector3 = mdt.get_vertex(i) * 5
		var flag := false
		for p in points:
			if (p - point_pos).length() < 0.0001 :
				points[p].append(i)
				flag = true
				break
		if !flag:
			points[point_pos] = [i]
		
		var marker := MarkerManager.new_marker_label_3d()
		add_child(marker)
		marker.text = str(i)
		marker.position = point_pos
		marker.font_size = 32
	print(points)
	#var shape : ConvexPolygonShape3D = $Area3D/CollisionShape3D.shape
	#shape.points[0] = Vector3(0, 0, 0)
	#shape.points[1] = Vector3(0, 1, 0)
	#shape.points[2] = Vector3(0, 0, 1)
	#shape.points[3] = Vector3(1, 0, 0)
	#shape.points.append(Vector3(0, 0, 0))
	#shape.points.append(Vector3(0, 1, 0))
	#shape.points.append(Vector3(0, 0, 1))
	#shape.points.append(Vector3(1, 0, 0))
	#shape.set_points([
		#Vector3(0, 0, 0),
		#Vector3(0, 1, 0),
		#Vector3(0, 0, 1),
		#Vector3(1, 0, 0),
	#])
	#$InteractionAreaForTerrain/CollisionShape3D.shape.set_points([
		#Vector3(-0.33889, 10.04763, -0.969644),
		#Vector3(-0.71588, 9.963996, -1.48873),
		#Vector3(-0.380086, 9.877888, -2.071928),
		#Vector3(0.379779, 9.877898, -2.07193),
		#Vector3(0.715576, 9.964017, -1.488733),
		#Vector3(0.338582, 10.04764, -0.969645),
		#Vector3(-0.332179, 9.848671, -0.950443),
		#Vector3(-0.701704, 9.766688, -1.45925),
		#Vector3(-0.37256, 9.682285, -2.0309),
		#Vector3(0.372258, 9.682296, -2.030902),
		#Vector3(0.701406, 9.766709, -1.459253),
		#Vector3(0.331878, 9.84868, -0.950444),
		
		#Vector3(-0.33889, 10.04763, -0.969644),
		#Vector3(-0.71588, 9.963996, -1.48873),
		#Vector3(-0.380086, 9.877888, -2.071928),
		#Vector3(0.379779, 9.877898, -2.07193),
		#Vector3(0.715576, 9.964017, -1.488733),
		#Vector3(0.338582, 10.04764, -0.969645),
		#Vector3(-0.332179, 9.848671, -0.950443),
		#Vector3(-0.701704, 9.766688, -1.45925),
		#Vector3(-0.37256, 9.682285, -2.0309),
		#Vector3(0.372258, 9.682296, -2.030902),
		#Vector3(0.701406, 9.766709, -1.459253),
		#Vector3(0.331878, 9.84868, -0.950444),
	#])
	#R.load_mod("main")
	
	#for i in 
	#var multi_mesh : MultiMesh = $MultiMeshInstance3D.multimesh
	#for i in 10000:
		#multi_mesh.set_instance_transform(i, Transform3D(Basis(Vector3.RIGHT, Vector3.UP, Vector3.BACK), $Lotus.position))
		#var m = $Lotus.duplicate()
		#m.visible = true
		#add_child(m)
	
	pass
	#var wo_shi_sha_bi := "我是傻逼"
	#var new_marker := MarkerManager.new_marker_label_3d()
	#new_marker.billboard = 0
	#new_marker.text = wo_shi_sha_bi
	#new_marker.font_size = 256
	#new_marker.modulate = Color.RED
	#add_child(new_marker)

func _process(delta):
	if Input.is_action_just_pressed("key_1"):
		#var a = R.batch_objects.get("@batch:main:lotus").instantiate()
		#add_child(a)
		#a.position = Vector3(
			#randf(),
			#randf(),
			#randf(),
		#)
		var multi_mesh : MultiMesh = $MultiMeshInstance3D.multimesh
		multi_mesh.set_instance_transform(0, Transform3D(Basis(Vector3.RIGHT, Vector3.UP, Vector3.BACK), $Lotus.position))
		multi_mesh.set_instance_transform(1, Transform3D(Basis(Vector3.RIGHT, Vector3.UP, Vector3.BACK), $Lotus2.position))
		multi_mesh.set_instance_transform(2, Transform3D(Basis(Vector3.RIGHT, Vector3.UP, Vector3.BACK), $Lotus3.position))
