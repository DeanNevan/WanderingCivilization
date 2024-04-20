extends MarginContainer

@onready var _CheckBox = $HBoxContainer/CheckBox
@onready var _Label = $HBoxContainer/Label

var text := ""
func set_text(_text):
		text = _text
var valid := false
func set_valid(_valid):
		valid = _valid

func init():
	_Label.text = tr(text)
	_CheckBox.button_pressed = valid
	_Label.modulate = Color.GREEN if valid else Color.RED
