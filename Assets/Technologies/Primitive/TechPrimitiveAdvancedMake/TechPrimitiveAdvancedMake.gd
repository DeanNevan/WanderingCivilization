extends "res://Assets/Scripts/BasicTechnology.gd"

onready var BronzeAge = get_parent().get_node("BronzeAge")
onready var TechPrimitiveMake = get_parent().get_node("TechPrimitiveMake")
onready var TechPrimitiveMetalMake = get_parent().get_node("TechPrimitiveMetalMake")
onready var TechPrimitiveMetalSmelting = get_parent().get_node("TechPrimitiveMetalSmelting")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始进阶制造"
	require_tech = {BronzeAge : 0.2, TechPrimitiveMake : 0.3, TechPrimitiveMetalMake : 0.5, TechPrimitiveMetalSmelting : 0.3}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
