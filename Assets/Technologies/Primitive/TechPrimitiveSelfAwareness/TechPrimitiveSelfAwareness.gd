extends "res://Assets/Scripts/BasicTechnology.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始自我意识"
	get_parent().get_parent().tech_done_count += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
