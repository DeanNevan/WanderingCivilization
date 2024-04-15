extends Node
class_name PlanetHandler

var id := "@planet_handler::default"
var planet : Planet

func change_script(target : GDScript):
	var temp = self.planet
	set_script(target)
	self.planet = temp

func handle_async():
	await get_tree().process_frame
	pass
