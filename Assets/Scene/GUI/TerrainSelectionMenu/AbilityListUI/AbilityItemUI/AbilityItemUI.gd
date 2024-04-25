extends MarginContainer

signal selected(ability_item_ui)

@onready var _Button = $Button
@onready var _LabelWarningTip = $ControlWarningTip/MarginContainer/MarginContainer/HBoxContainer/LabelWarningTip
@onready var _ControlWarningTip = $ControlWarningTip

var ability : ElementAbility

func init():
	
	update_all()

func update_all():
	_Button.icon = ability.icon
	_Button.text = tr(ability.ability_name)
	_Button.disabled = !ability.can_trigger()
	if ability.warning_string.length() > 0:
		_ControlWarningTip.show()
		_LabelWarningTip.text = tr(ability.warning_string)
	else:
		_ControlWarningTip.hide()
		

func delete():
	queue_free()

func _on_button_pressed():
	selected.emit(self)
	pass # Replace with function body.


func _on_button_mouse_entered():
	if is_instance_valid(ability):
		ability.focus()
	InputManager.change_focus_group_id("element_ability")
	pass # Replace with function body.


func _on_button_mouse_exited():
	if is_instance_valid(ability):
		ability.unfocus()
	if InputManager.focus_group_id == "element_ability":
		InputManager.change_focus_group_id("")
	pass # Replace with function body.
