extends Node3D
class_name MarkerBox3D

func set_color(new_color := Color.WHITE):
	$MeshInstance3D.material_override.albedo_color = new_color

func set_size(new_size := 0.1):
	var box_mesh : BoxMesh = $MeshInstance3D.mesh
	box_mesh.size = Vector3(new_size, new_size, new_size)
