extends Node3D
func _ready():
	R.load_mod("main")
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
