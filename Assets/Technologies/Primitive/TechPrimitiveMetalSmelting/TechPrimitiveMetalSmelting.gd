extends "res://Assets/Scripts/BasicTechnology.gd"

onready var TechPrimitiveMake = get_parent().get_node("TechPrimitiveMake")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始金属熔炼"
	require_tech = {TechPrimitiveMake : 1}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
