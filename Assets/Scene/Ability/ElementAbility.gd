extends Node
class_name ElementAbility

signal trigger_ended(ability)

@export var id := "@ability::default"
@export var ability_name := "@str::name_default_ability"
@export var info := "@str::info_default_ability"
@export var icon : Texture = preload("res://icon.svg")

var warning_string := ""

var element : TerrainElement:
	set(_element):
		element = _element
		
func set_element(_element):
	element = _element

var enabled := false

func focus():
	pass

func unfocus():
	pass

func can_trigger() -> bool:
	return true

func request_trigger():
	pass

func enable():
	enabled = true

func disable():
	enabled = false

func civilization_turn_operation_started(_civilization : Civilization):
	pass

func civilization_turn_operation_ended(_civilization : Civilization):
	pass
