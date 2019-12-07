extends "res://Assets/Scripts/BasicTechnology.gd"

onready var TechPrimitiveMetalSmelting = get_parent().get_node("TechPrimitiveMetalSmelting")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始金属制造"
	require_tech = {TechPrimitiveMetalSmelting : 1}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
