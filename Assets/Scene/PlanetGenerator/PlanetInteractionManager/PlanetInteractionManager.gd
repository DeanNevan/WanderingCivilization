extends Node3D
class_name PlanetInteractionManager

@export_node_path("Planet") var planet_node_path
@onready var planet : Planet = get_node(planet_node_path)
@onready var _AreasForTerrain = $AreasForTerrain
@onready var _TerrainFocusMarker_Focus = $TerrainFocusMarker_Focus
@onready var _TerrainFocusMarker_Select = $TerrainFocusMarker_Select

var Scene_InteractionAreaForTerrain := preload("res://Assets/Scene/PlanetGenerator/PlanetInteractionManager/InteractionArea/InteractionAreaForTerrain/InteractionAreaForTerrain.tscn")

var logger := LoggerManager.register_logger(self, "PH_NoiseBasedHeightLevelModifier")

var _focusing_terrain : PlanetTerrain
var _unfocused_terrain : PlanetTerrain
var selected_terrain : PlanetTerrain

func _ready():
	InputManager.connect("any_gesture", _on_input)

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

func _on_area_for_terrain_mouse_in(area : InteractionAreaForTerrain):
	planet.terrain_focus(area.target)
	_TerrainFocusMarker_Focus.set_and_enable(area.target)
	_focusing_terrain = area.target
	

func _on_area_for_terrain_mouse_out(area : InteractionAreaForTerrain):
	planet.terrain_unfocus(area.target)
	_TerrainFocusMarker_Focus.disable()
	_unfocused_terrain = area.target

func get_focusing_terrain():
	if is_instance_valid(_focusing_terrain):
		if _focusing_terrain == _unfocused_terrain:
			return null
		else:
			return _focusing_terrain
	return null

func terrain_select(_terrain : PlanetTerrain):
	planet.terrain_select(_terrain)
	selected_terrain = _terrain
	_TerrainFocusMarker_Select.set_and_enable(selected_terrain)
	_TerrainFocusMarker_Select.change_status_surge()

func terrain_unselect(_terrain : PlanetTerrain):
	planet.terrain_unselect(_terrain)
	selected_terrain = null
	_TerrainFocusMarker_Select.disable()

func _on_input(_sig : String, e : InputEventAction):
	if e is InputEventSingleScreenTap:
		var focusing_terrain : PlanetTerrain = get_focusing_terrain()
		if is_instance_valid(focusing_terrain):
			terrain_select(focusing_terrain)
			
		else:
			if is_instance_valid(selected_terrain):
				terrain_unselect(selected_terrain)
	pass
