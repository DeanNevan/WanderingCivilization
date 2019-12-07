extends "res://Assets/Scripts/BasicTechnology.gd"

onready var TechPrimitivePlant = get_parent().get_node("TechPrimitivePlant")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始畜牧"
	require_tech = {TechPrimitivePlant : 1}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
