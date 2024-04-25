extends Node
class_name TerrainSelector

signal confirmed(terrain)
signal canceled

@export var enable_valid_terrains := true
@export var planet : Planet
@export var valid_terrains := {}
@export var valid_check_function : Callable

@onready var _ButtonConfirm = $Control/MarginContainer/MarginContainer/VBoxContainer/ButtonConfirm
@onready var _Icon = $Control/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Icon
@onready var _LabelHeader = $Control/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/LabelHeader
@onready var _Control = $Control

var territory_manager := TerritoryManager.new("TerrainSelectorUI")
var territory_displayer : TerritoryDisplayer = preload("res://Assets/Scene/TerritoryDisplayer/TerritoryDisplayer.tscn").instantiate()

var marker_target : MarkerTarget = MarkerManager.new_marker_target()

var selected_terrain : PlanetTerrain

var header := ""
var icon : Texture = preload("res://icon.svg")

var enabled := false:
	set(_enabled):
		enabled = _enabled
		_ButtonConfirm.visible = enabled
		territory_displayer.enable()
		set_process(enabled)

func _ready():
	territory_displayer.territory_manager = territory_manager
	add_child(territory_displayer)
	add_child(marker_target)
	marker_target.disable()

func _process(_delta):
	if enabled and is_instance_valid(selected_terrain):
		var pos2d = get_viewport().get_camera_3d().unproject_position(selected_terrain.get_center_of_liquid())
		_Control.position = pos2d
	pass

func init():
	_Icon.texture = icon
	_LabelHeader.text = header
	
	territory_manager.clear()
	planet.connect("terrain_selected", _on_terrain_selected)
	planet.connect("terrain_unselected", _on_terrain_unselected)
	
	if enable_valid_terrains:
		for t in valid_terrains:
			territory_manager.add_terrain_count(t)
	
	territory_displayer.material.albedo_color = Color(Color.WHITE, 0.5)
	territory_displayer.material_edge.albedo_color = Color(Color.WHITE, 0.8)

func enable():
	enabled = true

func disable():
	enabled = false

func _on_terrain_selected(_terrain : PlanetTerrain):
	selected_terrain = _terrain
	marker_target.pos = _terrain.get_center_of_liquid()
	marker_target.enable()
	_Control.show()
	
	if !enable_valid_terrains:
		marker_target.set_valid(true)
	else:
		marker_target.set_valid(valid_terrains.has(_terrain))
	
	if valid_check_function != null and marker_target.valid:
		marker_target.valid = valid_check_function.call(_terrain)
	
	_ButtonConfirm.disabled = !marker_target.valid
	pass

func _on_terrain_unselected(_terrain : PlanetTerrain):
	marker_target.disable()
	_Control.hide()
	pass

func _on_button_confirm_pressed():
	confirmed.emit(selected_terrain)
	pass # Replace with function body.

func delete():
	territory_manager.clear()
	queue_free()


func _on_button_cancel_pressed():
	canceled.emit()
	pass # Replace with function body.
