extends Area3D
class_name InteractionArea

signal mouse_in(area)
signal mouse_out(area)

@onready var _CollisionShape3D = $CollisionShape3D

var target
var enabled := true

func init():
	pass

func bind_target(_target):
	target = _target
	init()

func _on_mouse_entered():
	if enabled and is_instance_valid(target):
		mouse_in.emit(self)
	pass # Replace with function body.


func _on_mouse_exited():
	if enabled and is_instance_valid(target):
		mouse_out.emit(self)
	pass # Replace with function body.
