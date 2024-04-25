extends Control

@onready var _OptionButtonElements = $VBoxContainer/OptionButtonElements
@onready var _VBoxContainer = $VBoxContainer
@onready var _AbilityListUI = $AbilityListUI

var enabled := false

var terrain : PlanetTerrain:
	set(_terrain):
		terrain = _terrain
		init_option_button_elements()

func set_terrain(_terrain):
	terrain = _terrain

var idx_to_elements := {
}

var selected_element : TerrainElement

func _ready():
	init_option_button_elements()

func _process(_delta):
	if is_instance_valid(terrain) and enabled:
		var camera : Camera3D = get_viewport().get_camera_3d()
		var position2d : Vector2 = camera.unproject_position(terrain.get_center())
		global_position = position2d
		_AbilityListUI.position = -_AbilityListUI.size / 2.0
		#global_position = position2d

func init():
	init_option_button_elements()

func enable():
	show()
	enabled = true
	set_process(true)
	update_element_selection()

func disable():
	hide()
	enabled = false
	set_process(false)

func update_element_selection():
	selected_element = idx_to_elements.get(_OptionButtonElements.get_selected_id())
	update_ability_list_ui()

func update_ability_list_ui():
	_AbilityListUI.element = selected_element
	_AbilityListUI.init()

func init_option_button_elements():
	_OptionButtonElements.clear()
	if !is_instance_valid(terrain):
		return
	for layer in terrain.elements:
		for _element in terrain.elements[layer]:
			var element : TerrainElement = _element
			_OptionButtonElements.add_item(tr(element.element_name), idx_to_elements.size())
			idx_to_elements[idx_to_elements.size()] = element

func _on_option_button_elements_item_selected(index):
	if index == 0:
		return
	selected_element = idx_to_elements.get(index)
	update_ability_list_ui()
	pass # Replace with function body.

func _on_check_box_detail_toggled(toggled_on):
	pass # Replace with function body.


func _on_v_box_container_mouse_entered():
	_VBoxContainer.modulate.a = 1.0
	pass # Replace with function body.


func _on_v_box_container_mouse_exited():
	_VBoxContainer.modulate.a = 0.4
	pass # Replace with function body.
