extends "res://Assets/Scripts/BasicTechnology.gd"

onready var BronzeAge = get_parent().get_node("BronzeAge")
onready var TechPrimitiveCollect = get_parent().get_node("TechPrimitiveCollect")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始进阶采集"
	require_tech = {BronzeAge : 0.2, TechPrimitiveCollect : 0.8}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
