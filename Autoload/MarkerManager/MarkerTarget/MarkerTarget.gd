extends Node2D
class_name MarkerTarget

var pos := Vector3()
var enabled := false:
	set(_enabled):
		enabled = _enabled
		set_process(enabled)
		visible = enabled

var valid := true:
	set(_valid):
		valid = _valid
		if valid:
			modulate = Color.WHITE
		else:
			modulate = Color.RED

func set_valid(_valid):
	valid = _valid

func enable():
	enabled = true

func disable():
	enabled = false

func _process(_delta):
	var pos2d = get_viewport().get_camera_3d().unproject_position(pos)
	position = pos2d
	pass
