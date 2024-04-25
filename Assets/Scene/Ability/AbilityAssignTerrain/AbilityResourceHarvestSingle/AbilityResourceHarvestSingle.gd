extends AbilityAssignTerrain
class_name AbilityResourceHarvestSingle

@export var valid_resource_id := []
@export var health_cost := 1
@export var assets_per_turn := {}

var target_resource : TerrainElement

func is_target_valid(_target : PlanetTerrain) -> bool:
	if !super.is_target_valid(_target):
		return false
	for i in valid_resource_id:
		if _target.has_element(i):
			return true
	return false

func select_terrain(_terrain : PlanetTerrain):
	super.select_terrain(_terrain)
	for i in valid_resource_id:
		var element = _terrain.get_element_via_id(i)
		if !is_instance_valid(element):
			continue
		target_resource = element

func civilization_turn_operation_started(_civilization : Civilization):
	super.civilization_turn_operation_started(_civilization)
	if !(element is TerrainArtificial):
		return 
	if element.civilization != _civilization:
		return
	if !enabled || !is_instance_valid(target_resource):
		if !is_instance_valid(target_resource):
			warning_string = "@str::invalid_target"
		return
	target_resource.get_damage(health_cost)
	for asset_id in assets_per_turn:
		_civilization.asset_manager.add_asset(asset_id, assets_per_turn[asset_id])

func civilization_turn_operation_ended(_civilization : Civilization):
	super.civilization_turn_operation_ended(_civilization)
