extends "res://Assets/Scripts/BasicTechnology.gd"

onready var BronzeAge = get_parent().get_node("BronzeAge")
onready var TechPrimitiveMetalSmelting = get_parent().get_node("TechPrimitiveMetalSmelting")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始进阶金属熔炼"
	require_tech = {BronzeAge : 0.2, TechPrimitiveMetalSmelting : 0.8}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
