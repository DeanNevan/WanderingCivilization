extends "res://Assets/Scripts/BasicTechnology.gd"

onready var TechPrimitiveHunt = get_parent().get_node("TechPrimitiveHunt")
onready var TechPrimitiveTotemism = get_parent().get_node("TechPrimitiveTotemism")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始驯兽"
	require_tech = {TechPrimitiveHunt : 0.4, TechPrimitiveTotemism : 0.7}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
