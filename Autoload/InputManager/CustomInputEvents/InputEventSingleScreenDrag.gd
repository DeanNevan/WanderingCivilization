# @category: Utils/InputManager/Events
class_name InputEventSingleScreenDrag
extends InputEventAction

var position
var relative
var speed

func _init(e):
	position = e.position
	relative = e.relative
	speed = e.velocity


#func as_text():
#	return "InputEventSingleScreenDrag : position=" + str(position) + ", relative=" + str(relative) + ", speed=" + str(speed)
