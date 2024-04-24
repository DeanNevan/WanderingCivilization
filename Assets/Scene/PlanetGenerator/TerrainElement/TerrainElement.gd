extends Node3D
class_name TerrainElement

signal health_changed(resource)
var max_health := 100
var health := 100

class RequirementElement:
	extends Requirement
	var element : TerrainElement
	func _init(_element):
		element = _element
	func _to_string():
		return "@str::default_element_requirement"
	func check(_terrain : PlanetTerrain) -> bool:
		return true

# 小于0的元素视作不独占地块
class RequirementLayer:
	extends RequirementElement
	func _to_string():
		return tr("@str::requirement_no_other_element") % element.layer
	func check(_terrain : PlanetTerrain) -> bool:
		if element.layer < 0:
			return true
		var elements : Dictionary = _terrain.get_elements()
		for layer in elements:
			if layer < 0:
				continue
			for i in elements[layer]:
				if !(i is TerrainResourceLiquid):
					if layer == element.layer:
						return false
		return true

class RequirementLiquid:
	extends RequirementElement
	func _to_string():
		if element.only_with_liquid:
			return tr("@str::requirement_only_on_liquid") % tr(element.type_name)
		elif !element.can_with_liquid:
			return tr("@str::requirement_cannot_with_liquid") % tr(element.type_name)
		else:
			return ""
	func check(_terrain : PlanetTerrain) -> bool:
		if element.only_with_liquid and !_terrain.has_liquid():
			return false
		if !element.can_with_liquid and _terrain.has_liquid():
			return false
		return true

class RequirementTerrain:
	extends RequirementElement
	var white_list := []
	var black_list := []
	func _init(_element, _white_list := [], _black_list := []):
		super._init(_element)
		white_list = _white_list
		black_list = _black_list
	
	func _to_string():
		return tr("@str::requirement_terrain") % tr(element.type_name)
	
	func check(_terrain : PlanetTerrain) -> bool:
		var flag := true
		if white_list.size() > 0:
			flag = false
			for terrain_id in white_list:
				if _terrain.id == terrain_id:
					flag = true
					break
		else:
			flag = true
		if !flag:
			return false
		
		for terrain_id in black_list:
			if _terrain.id == terrain_id:
				flag = false
				break
		if !flag:
			return false
		return true

class RequirementEnvFactor:
	extends RequirementElement
	var require := {}
	var black_list := []
	func _init(_element, _require := {}, _black_list := []):
		super._init(_element)
		require = _require
		black_list = _black_list
	
	func _to_string():
		return tr("@str::requirement_env_factor") % tr(element.type_name)
	
	func check(_terrain : PlanetTerrain) -> bool:
		var factors : Dictionary = _terrain.get_current_env_factors()
		var flag := true
		for factor_id in black_list:
			if factors.has(factor_id):
				if factors[factor_id] > 0:
					flag = false
					break
		if !flag:
			return false
		
		flag = true
		for factor_id in require:
			if factors.has(factor_id):
				if factors[factor_id] < require[factor_id]:
					flag = false
					break
			else:
				flag = false
				break
		if !flag:
			return false
		
		return true

func added_to_terrain():
	pass

#class RequirementResource:
	#var require := {}
	#
	#func _init(_require):
		#require = _require
	#
	#func check(_terrain : PlanetTerrain) -> bool:
		#for 
		#return true

class Ability:
	var ability_name := ""
	var info := ""
	
	var element : TerrainElement
	
	var is_active := false
	
	func _init(_element):
		element = _element
	
	func can_activate() -> bool:
		return true
	
	func activate():
		if can_activate():
			is_active = true
	
	func inactivate():
		is_active = false
	
	func trigger():
		pass
	pass

class AbilityOneShot:
	pass

class AbilityEveryTurn:
	pass

var abilities := []

@export var id := "@element::default"
@export var info := "@str::default_element_info"
@export var element_name := "@str::default_element_name"
@export var type_name := "@str::element_type_name"

@export var on_liquid_surface := false
@export var only_with_liquid := false
@export var can_with_liquid := false
@export var layer := 0

var terrain : PlanetTerrain

var env_factors_id_modification := {}
var env_factors_id_modification_neighbour := {}

var requirements := []

func _init():
	health_changed.connect(_on_self_health_changed)

func trigger_all_abilities_every_turn():
	for a in abilities:
		if a is TerrainElement.AbilityEveryTurn:
			if a.is_active():
				a.trigger()

func add_ability(_ability : TerrainElement.Ability):
	abilities.append(_ability)

func init():
	pass

func delete():
	queue_free()

func init_display():
	pass

func add_requirement(_requirement):
	requirements.append(_requirement)

func meet_requirements(_terrain := terrain) -> bool:
	for r in requirements:
		if !r.check(_terrain):
			return false
	return true

func increase_health(amount : int):
	if amount <= 0:
		return
	var old := health
	health = clamp(health + amount, 0, max_health)
	if old != health:
		health_changed.emit()

func decrease_health(amount : int):
	if amount <= 0:
		return
	var old := health
	health = clamp(health - amount, 0, max_health)
	if old != health:
		health_changed.emit(self)

func get_demo_model_scene():
	return null

func _on_self_health_changed(_resource):
	pass

func add_model_scene(scene : Node3D):
	add_child(scene)
	terrain.place_model_scene(scene, on_liquid_surface and can_with_liquid)
