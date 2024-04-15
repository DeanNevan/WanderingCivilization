extends BatchObject
class_name BatchModelScene

func copy_to(target : BatchObject):
	for my_node_i in get_children(true).size():
		var my_node = get_child(my_node_i, true)
		if !(my_node is MeshInstance3D):
			continue
		var tar_node = target.get_child(my_node_i, true)
		if is_instance_valid(tar_node):
			if tar_node is MeshInstance3D:
				tar_node.mesh = my_node.mesh
