extends "res://Assets/Scripts/BasicTechnology.gd"

onready var TechPrimitiveText = get_parent().get_node("TechPrimitiveText")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始艺术"
	require_tech = {TechPrimitiveText : 1}
	get_parent().get_parent().tech_done_count += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
