extends "res://Assets/Scripts/BasicTechnology.gd"

onready var TechPrimitiveCollect = get_parent().get_node("TechPrimitiveCollect")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始种植"
	require_tech = {TechPrimitiveCollect : 1}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
