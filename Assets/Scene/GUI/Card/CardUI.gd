extends MarginContainer
class_name CardUI

signal focused(card_ui)
signal unfocused(card_ui)

var card : Card

@onready var _ListCardCostMark = $VBoxContainer/MarginContainer/Control/Control/MarginContainer/ListCardCostMark
@onready var _LabelName = $VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/LabelName
@onready var _LabelInfo = $VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/MarginContainer3/LabelInfo
@onready var _Icon = $VBoxContainer/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/Icon
@onready var _HeaderPanel = $VBoxContainer/HeaderPanel
@onready var _PanelBG2 = $VBoxContainer/MarginContainer/PanelBG2

var is_markers_invalid := false
var header_panel_enabled := false

var is_focused := false
var is_selected := false

func set_card(_card):
	card = _card

func set_markers_invalid():
	is_markers_invalid = true

func set_header_panel_enabled(enabled : bool):
	header_panel_enabled = enabled
	if !enabled:
		hide_header_panel()

func update_all():
	if is_selected:
		_PanelBG2.show()
		if card.civilization.asset_manager.can_consume_assets(card.get_cost()):
			_PanelBG2.modulate = Color.GREEN
		else:
			_PanelBG2.modulate = Color.RED
		_HeaderPanel.hide()
	elif is_focused:
		_PanelBG2.hide()
		_HeaderPanel.hide()
	else:
		_PanelBG2.hide()
		_HeaderPanel.show()
	_ListCardCostMark.update_all()

func delete():
	queue_free()

func init():
	if !is_instance_valid(card):
		return
	_LabelName.text = card.card_name
	_LabelInfo.text = card.info
	_Icon.texture = card.icon
	_ListCardCostMark.set_card(card)
	if is_markers_invalid:
		_ListCardCostMark.set_markers_invalid()
	_ListCardCostMark.init()
	pass

func show_header_panel():
	if header_panel_enabled:
		_HeaderPanel.show()

func hide_header_panel():
	_HeaderPanel.hide()

func select():
	is_selected = true
	update_all()
	#_PanelBG2.show()

func unselect():
	is_selected = false
	update_all()
	#_PanelBG2.hide()

func focus():
	is_focused = true
	update_all()

func unfocus():
	is_focused = false
	update_all()

func _on_mouse_entered():
	focused.emit(self)
	pass # Replace with function body.


func _on_mouse_exited():
	unfocused.emit(self)
	pass # Replace with function body.


func _on_panel_bg_gui_input(event):
	InputManager.feed_event(event)
	pass # Replace with function body.
