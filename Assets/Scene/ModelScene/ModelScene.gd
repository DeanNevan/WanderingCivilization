extends Node
class_name ModelScene

var mesh_instances := []

var material_demo := preload("res://Assets/Material/MaterialModelDemo.tres")
var material_demo_invalid := preload("res://Assets/Material/MaterialModelDemoInvalid.tres")

func _ready():
	update_mesh_instances()

func delete():
	queue_free()

func update_mesh_instances():
	mesh_instances.clear()
	for i in get_children(true):
		if i is MeshInstance3D:
			mesh_instances.append(i)
	pass

func demo_display(valid := true):
	for m in mesh_instances:
		m.material_override = material_demo if valid else material_demo_invalid
	pass

func normal_display():
	for m in mesh_instances:
		m.material_override = null
