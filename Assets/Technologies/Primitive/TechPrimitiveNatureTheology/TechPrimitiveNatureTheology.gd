extends "res://Assets/Scripts/BasicTechnology.gd"

onready var BronzeAge = get_parent().get_node("BronzeAge")
onready var TechPrimitiveTotemism = get_parent().get_node("TechPrimitiveTotemism")
onready var TechPrimitiveAstrology = get_parent().get_node("TechPrimitiveAstrology")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始自然信仰"
	require_tech = {BronzeAge : 0.4, TechPrimitiveTotemism : 0.6, TechPrimitiveAstrology : 0.4}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
