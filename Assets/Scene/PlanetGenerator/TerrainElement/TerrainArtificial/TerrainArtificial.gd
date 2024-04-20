extends TerrainElement
class_name TerrainArtificial

#class RequirementCost:
	#extends Requirement
	#var artificial : TerrainArtificial
	#func _init(_artificial):
		#artificial = _artificial
	#func check(_terrain : PlanetTerrain) -> bool:
		#
		#return true

@export var maintain_cost := {}
@export var create_cost := {}

var civilization : Civilization
var outpost := false # 前哨，可以建造在边疆以外
var expand_borderland := 1 # 拓展边疆格子数

func _init():
	super._init()
	type_name = "@str::artificial_type_name"

func check_create_cost() -> bool:
	for i in create_cost:
		if !civilization.asset_manager.can_consume_asset(i, create_cost[i]):
			return false
	return true

func check_maintain_cost() -> bool:
	for i in maintain_cost:
		if !civilization.asset_manager.can_consume_asset(i, maintain_cost[i]):
			return false
	return true

func create(neglect_check := false):
	if check_create_cost() || neglect_check:
		for i in create_cost:
			civilization.asset_manager.consume_asset(i, create_cost[i])

func maintain(neglect_check := false):
	if check_maintain_cost() || neglect_check:
		for i in maintain_cost:
			civilization.asset_manager.consume_asset(i, maintain_cost[i])


