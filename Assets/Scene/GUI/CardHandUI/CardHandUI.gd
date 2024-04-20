extends MarginContainer
@onready var _ListCard = $Control/ListCard

signal card_selected(card)
signal card_unselected(card)

var Scene_CardUI := preload("res://Assets/Scene/GUI/Card/CardUI.tscn")

var civilization : Civilization

var _focusing_card_ui : CardUI
var _unfocused_card_ui : CardUI
var selected_card_ui : CardUI

func _ready():
	InputManager.connect("any_gesture", _on_input)

func set_civilization(_civilization):
	civilization = _civilization
	if !civilization.asset_manager.asset_changed.is_connected(_on_asset_changed):
		civilization.asset_manager.asset_changed.connect(_on_asset_changed)

func clear():
	for i in _ListCard.get_children():
		i.queue_free()

func add_card(card : Card):
	var new_card_ui : CardUI = Scene_CardUI.instantiate()
	_ListCard.add_child(new_card_ui)
	new_card_ui.set_card(card)
	new_card_ui.init()
	new_card_ui.set_header_panel_enabled(true)
	new_card_ui.show_header_panel()
	new_card_ui.focused.connect(_on_card_focused)
	new_card_ui.unfocused.connect(_on_card_unfocused)
	update_all()

func remove_card(card : Card):
	for i in _ListCard.get_children():
		if i.card != card:
			continue
		var card_ui : CardUI = i
		card_ui.delete()
		update_all()

func update_all():
	update_all_card_ui()

func update_all_card_ui():
	for i in _ListCard.get_children():
		i.update_all()

func _on_card_focused(card_ui : CardUI):
	_focusing_card_ui = card_ui
	_unfocused_card_ui = null
	card_ui.focus()
	InputManager.change_focus_group_id("hand_cards")

func _on_card_unfocused(card_ui : CardUI):
	_unfocused_card_ui = card_ui
	card_ui.unfocus()
	if InputManager.focus_group_id == "hand_cards":
		InputManager.change_focus_group_id("")

func get_selected_card():
	if is_instance_valid(selected_card_ui):
		return selected_card_ui.card
	else:
		return null

func get_focusing_card_ui():
	if is_instance_valid(_focusing_card_ui):
		if _focusing_card_ui == _unfocused_card_ui:
			return null
		else:
			return _focusing_card_ui
	return null

func card_ui_select(_card_ui : CardUI):
	selected_card_ui = _card_ui
	selected_card_ui.select()
	card_selected.emit(_card_ui.card)

func card_ui_unselect(_card_ui : CardUI):
	selected_card_ui.unselect()
	selected_card_ui = null
	card_unselected.emit(_card_ui.card)

func _on_input(_sig : String, e : InputEventAction):
	if e is InputEventSingleScreenTap:
		var focusing_card_ui : CardUI = get_focusing_card_ui()
		if is_instance_valid(focusing_card_ui):
			var flag : bool = selected_card_ui == focusing_card_ui
			if is_instance_valid(selected_card_ui):
				card_ui_unselect(selected_card_ui)
			if !flag:
				card_ui_select(focusing_card_ui)
		#else:
			#if is_instance_valid(selected_card_ui):
				#card_ui_unselect(selected_card_ui)

func _on_asset_changed(_asset):
	update_all()
	pass
