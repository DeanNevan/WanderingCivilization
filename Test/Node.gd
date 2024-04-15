extends Node

var value := 123
var values := []

func _ready():
	pass
	#for i in 100000:
		#values.append(i)

func change_script(target : GDScript):
	var _value = value
	var _values = values
	set_script(target)
	value = _value
	values = _values

