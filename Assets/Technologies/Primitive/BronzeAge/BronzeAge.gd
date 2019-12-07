extends "res://Assets/Scripts/BasicTechnology.gd"

onready var TechPrimitiveMetalMake = get_parent().get_node("TechPrimitiveMetalMake")

# Called when the node enters the scene tree for the first time.
func _ready():
	require_tech = {TechPrimitiveMetalMake : 1}
	name_CN = "青铜时代"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
