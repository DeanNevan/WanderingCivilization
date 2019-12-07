extends "res://Assets/Scripts/BasicTechnology.gd"

onready var TechPrimitiveSelfAwareness = get_parent().get_node("TechPrimitiveSelfAwareness")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "石器时代"
	require_tech = {TechPrimitiveSelfAwareness : 1}
	get_parent().get_parent().tech_done_count += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
