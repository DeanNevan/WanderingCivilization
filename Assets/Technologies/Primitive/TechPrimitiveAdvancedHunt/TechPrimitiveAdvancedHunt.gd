extends "res://Assets/Scripts/BasicTechnology.gd"

onready var BronzeAge = get_parent().get_node("BronzeAge")
onready var TechPrimitiveHunt = get_parent().get_node("TechPrimitiveHunt")
onready var TechPrimitiveAdvancedMake = get_parent().get_node("TechPrimitiveAdvancedMake")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始进阶狩猎"
	require_tech = {BronzeAge : 0.2, TechPrimitiveHunt : 0.6, TechPrimitiveAdvancedMake : 0.4}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
