extends "res://Assets/Scripts/BasicTechnology.gd"

onready var BronzeAge = get_parent().get_node("BronzeAge")
onready var TechPrimitivePlant = get_parent().get_node("TechPrimitivePlant")
onready var TechPrimitiveAdvancedCollect = get_parent().get_node("TechPrimitiveAdvancedCollect")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始进阶种植"
	require_tech = {BronzeAge : 0.2, TechPrimitivePlant : 0.6, TechPrimitiveAdvancedCollect : 0.3}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
