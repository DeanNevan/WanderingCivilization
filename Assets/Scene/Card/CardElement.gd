extends Card
class_name CardElement

@export var element_script : GDScript
var element_instance : TerrainElement

func use(_terrain : PlanetTerrain):
	super.use(_terrain)
	_terrain.add_element(element_instance)
	#civilization.asset_manager.consume_asset()

func get_common_info_tips() -> Array:
	var arr : Array = super.get_common_info_tips()
	for i in element_instance.get_common_info_tips():
		arr.append(i)
	return arr

func init():
	super.init()
	assert(is_instance_valid(element_script))
	element_instance = element_script.new()
	requirements = element_instance.requirements
	element_instance.civilization = civilization
	init_cost()

func init_cost():
	super.init_cost()
	
