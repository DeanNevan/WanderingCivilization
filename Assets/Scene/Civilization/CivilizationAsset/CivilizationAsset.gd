extends Node
class_name CivilizationAsset

signal used_out(asset)
signal changed(asset)
signal increased(asset)
signal decreased(asset)

var value := 0

var id := ""
var asset_name := ""
var info := ""

var icon : Texture

func can_consume(_consume_value : int) -> bool:
	return value >= _consume_value

func consume(_consume_value : int):
	if can_consume(_consume_value):
		value -= _consume_value
		changed.emit(self)
		decreased.emit(self)
		if value == 0:
			used_out.emit(self)

func add(_add_value : int):
	value += _add_value
	changed.emit(self)
	increased.emit(self)
