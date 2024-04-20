extends Node3D
class_name PlanetInteractionManager

@export_node_path("Planet") var planet_node_path
@onready var planet : Planet = get_node(planet_node_path)
@onready var _AreasForTerrain = $AreasForTerrain
@onready var _TerrainFocusMarker_Focus = $TerrainFocusMarker_Focus
@onready var _TerrainFocusMarker_Select = $TerrainFocusMarker_Select

var Scene_InteractionAreaForTerrain := preload("res://Assets/Scene/PlanetGenerator/PlanetInteractionManager/InteractionArea/InteractionAreaForTerrain/InteractionAreaForTerrain.tscn")

var logger := LoggerManager.register_logger(self, "PH_NoiseBasedHeightLevelModifier")

var _focusing_area : InteractionAreaForTerrain
var _unfocused_area : InteractionAreaForTerrain
var selected_area : InteractionAreaForTerrain

func _ready():
	InputManager.connect("any_gesture", _on_input)
	InputManager.connect("focus_group_id_changed", _on_focus_group_id_changed)

func init_terrains():
	logger.debug("初始化地形检测")
	var time_start : int = Time.get_ticks_msec()
	
	for t in planet.terrains:
		var new_area : InteractionAreaForTerrain = Scene_InteractionAreaForTerrain.instantiate()
		_AreasForTerrain.add_child(new_area)
		new_area.connect("mouse_in", _on_area_for_terrain_mouse_in)
		new_area.connect("mouse_out", _on_area_for_terrain_mouse_out)
		new_area.bind_target(t)
	
	var time_end : int = Time.get_ticks_msec()
	logger.debug("耗时:%dms" % (time_end - time_start))

func get_selected_terrain():
	if is_instance_valid(selected_area):
		return selected_area.target
	else:
		return null 

func _on_area_for_terrain_mouse_in(area : InteractionAreaForTerrain):
	planet.terrain_focus(area.target)
	_TerrainFocusMarker_Focus.set_and_enable(area.target)
	_focusing_area = area
	_unfocused_area = null
	InputManager.change_focus_group_id("terrains")
	

func _on_area_for_terrain_mouse_out(area : InteractionAreaForTerrain):
	planet.terrain_unfocus(area.target)
	_TerrainFocusMarker_Focus.disable()
	_unfocused_area = area
	if InputManager.focus_group_id == "terrains":
		InputManager.change_focus_group_id("")

func get_focusing_terrain():
	if is_instance_valid(_focusing_area):
		if _focusing_area == _unfocused_area:
			return null
		else:
			return _focusing_area.target
	return null

func get_focusing_area():
	if is_instance_valid(_focusing_area):
		if _focusing_area == _unfocused_area:
			return null
		else:
			return _focusing_area
	return null

func terrain_area_select(_area : InteractionAreaForTerrain):
	selected_area = _area
	_TerrainFocusMarker_Select.set_and_enable(selected_area.target)
	_TerrainFocusMarker_Select.change_status_surge()
	planet.terrain_select(_area.target)

func terrain_area_unselect(_area : InteractionAreaForTerrain):
	selected_area = null
	_TerrainFocusMarker_Select.disable()
	planet.terrain_unselect(_area.target)

func _on_input(_sig : String, e : InputEventAction):
	if e is InputEventSingleScreenTap:
		var focusing_area : InteractionAreaForTerrain = get_focusing_area()
		if is_instance_valid(focusing_area):
			terrain_area_select(focusing_area)
			
		else:
			if is_instance_valid(selected_area) && InputManager.focus_group_id == "":
				terrain_area_unselect(selected_area)
	pass

func _on_focus_group_id_changed():
	if InputManager.focus_group_id != "terrains":
		if is_instance_valid(_focusing_area):
			_on_area_for_terrain_mouse_out(_focusing_area)
	pass
