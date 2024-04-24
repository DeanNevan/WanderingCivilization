extends TerrainElement
class_name TerrainArtificial

class RequirementCivilizationTerritory:
	extends RequirementElement
	func _to_string():
		if element.core:
			return ""
		elif element.outpost:
			return tr("@str::requirement_civilization_territory_outpost") % tr(element.type_name)
		else:
			return tr("@str::requirement_civilization_territory") % tr(element.type_name)
	func check(_terrain : PlanetTerrain) -> bool:
		if element.core:
			return true
		else:
			var terrain : PlanetTerrain = _terrain
			var level := 0
			if element.outpost:
				level = 1
			for t in terrain.get_neighbour_terrains_via_level(level):
				if is_instance_valid(t.get_territory("civilization")):
					if t.get_territory("civilization").manager.civilization == element.civilization:
						return true
		return false

@export var maintain_cost := {}
@export var create_cost := {}

var civilization : Civilization
var outpost := false # 前哨，可以建造在边疆的相邻位置，但没有作为核心的功能
var core := false # 核心，可以建造在边疆以外，同时，会将该领域纳入文明，视作整体
var expand_borderland := 1 # 拓展边疆格子数

func _init():
	super._init()
	type_name = "@str::artificial_type_name"

func get_common_info_tips() -> Array:
	var arr : Array = super.get_common_info_tips()
	if core:
		arr.append("[color=red]" + tr("@str::core") + "[/color]")
	elif outpost:
		arr.append("[color=red]" + tr("@str::outpost") + "[/color]")
	arr.append(tr("@str::expand_border") + ":%d" % expand_borderland)
	if maintain_cost.size() > 0:
		var str := ""
		for id in maintain_cost:
			var icon_path : String = R.get_asset_instance(id).icon.resource_path
			var value : int = maintain_cost[id]
			if str.length() > 0:
				str += ","
			str += ("%d" % value) + ("[img=<16>]%s[/img]" % icon_path)
		if str.length() > 0:
			arr.append("%s:%s" % [tr("@str::maintain_cost"), str])
	return arr

func added_to_terrain():
	super.added_to_terrain()
	civilization.territory_manager.artificial_added(self)
	pass

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


