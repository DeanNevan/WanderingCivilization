extends "res://Assets/Scripts/BasicTechnology.gd"

onready var BronzeAge = get_parent().get_node("BronzeAge")
onready var TechPrimitiveArt = get_parent().get_node("TechPrimitiveArt")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始进阶艺术"
	require_tech = {BronzeAge : 0.2, TechPrimitiveArt : 0.8}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
