extends "res://Assets/Scripts/BasicTechnology.gd"

onready var BronzeAge = get_parent().get_node("BronzeAge")
onready var TechPrimitiveRaise = get_parent().get_node("TechPrimitiveRaise")
onready var TechPrimitiveAdvancedPlant = get_parent().get_node("TechPrimitiveAdvancedPlant")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始进阶畜牧"
	require_tech = {BronzeAge : 0.2, TechPrimitiveRaise : 0.5, TechPrimitiveAdvancedPlant : 0.5}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
