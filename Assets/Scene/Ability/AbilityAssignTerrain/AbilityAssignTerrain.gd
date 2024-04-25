extends ElementAbility
class_name AbilityAssignTerrain

@export var exclude_self := true
@export var radius := 1

var Scene_TerrainSelector : PackedScene = preload("res://Assets/Scene/TerrainSelector/TerrainSelector.tscn")

var selected_terrain : PlanetTerrain

var focus_marker_target : MarkerTarget = MarkerManager.new_marker_target()

var terrain_selector : TerrainSelector

func _ready():
	warning_string = "@str::invalid_target"
	add_child(focus_marker_target)
	focus_marker_target.disable()

func request_trigger():
	InputManager.change_special_work_status_id("ability_selecting_terrain")
	if !is_instance_valid(terrain_selector):
		terrain_selector = Scene_TerrainSelector.instantiate()
		GUI.add_child(terrain_selector)
		terrain_selector.confirmed.connect(_on_terrain_selector_confirmed)
		terrain_selector.canceled.connect(_on_terrain_selector_canceled)
	
	terrain_selector.header = tr(ability_name)
	terrain_selector.icon = icon
	
	terrain_selector.planet = element.terrain.planet
	terrain_selector.valid_check_function = is_target_valid
	if radius >= 0:
		terrain_selector.enable_valid_terrains = true
		terrain_selector.valid_terrains = {}
		for t in element.terrain.get_neighbour_terrains_via_level(radius, exclude_self):
			terrain_selector.valid_terrains[t] = true
	else:
		terrain_selector.enable_valid_terrains = false
		terrain_selector.valid_terrains = {}
	
	terrain_selector.init()
	terrain_selector.enable()
	
	terrain_selector._on_terrain_selected(element.terrain)
	pass

func is_target_valid(_target : PlanetTerrain) -> bool:
	return true

func focus():
	super.focus()
	if is_instance_valid(selected_terrain):
		focus_marker_target.pos = selected_terrain.get_center_of_liquid()
		focus_marker_target.enable()

func unfocus():
	super.unfocus()
	if is_instance_valid(selected_terrain):
		focus_marker_target.disable()

func select_terrain(_terrain : PlanetTerrain):
	selected_terrain = _terrain

func _on_terrain_selector_confirmed(_terrain : PlanetTerrain):
	InputManager.change_special_work_status_id("")
	select_terrain(_terrain)
	if is_instance_valid(terrain_selector):
		terrain_selector.delete()
	trigger_ended.emit(self)
	warning_string = ""

func _on_terrain_selector_canceled():
	InputManager.change_special_work_status_id("")
	if is_instance_valid(terrain_selector):
		terrain_selector.delete()
	trigger_ended.emit(self)

func civilization_turn_operation_started(_civilization : Civilization):
	super.civilization_turn_operation_started(_civilization)

func civilization_turn_operation_ended(_civilization : Civilization):
	super.civilization_turn_operation_ended(_civilization)
