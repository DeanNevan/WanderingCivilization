extends CircularContainer

var element : TerrainElement

var Scene_AbilityItemUI := preload("res://Assets/Scene/GUI/TerrainSelectionMenu/AbilityListUI/AbilityItemUI/AbilityItemUI.tscn")

func init():
	for i in get_children():
		i.delete()
	if !is_instance_valid(element):
		return
	if element.abilities.size() == 0:
		hide()
		return
	show()
	for a in element.abilities:
		var ability : ElementAbility = a
		if !ability.is_connected("trigger_ended", _on_ability_trigger_ended):
			ability.connect("trigger_ended", _on_ability_trigger_ended)
		var ability_item_ui = Scene_AbilityItemUI.instantiate()
		add_child(ability_item_ui)
		ability_item_ui.ability = ability
		ability_item_ui.init()
		ability_item_ui.selected.connect(_on_ability_item_ui_selected)
	_on_sort_children()

func _on_ability_item_ui_selected(_ability_item_ui):
	var ability : ElementAbility = _ability_item_ui.ability
	ability.request_trigger()
	hide()

func _on_ability_trigger_ended(_ability : ElementAbility):
	pass
