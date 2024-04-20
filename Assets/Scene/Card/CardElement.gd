extends Card
class_name CardElement

@export var element_script : GDScript
var element_instance : TerrainElement



func init():
	super.init()
	assert(is_instance_valid(element_script))
	element_instance = element_script.new()
	requirements = element_instance.requirements
	init_cost()

func init_cost():
	super.init_cost()
	
