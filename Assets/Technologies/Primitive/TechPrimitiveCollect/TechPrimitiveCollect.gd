extends "res://Assets/Scripts/BasicTechnology.gd"

onready var StoneAge = get_parent().get_node("StoneAge")

# Called when the node enters the scene tree for the first time.
func _ready():
	name_CN = "原始采集"
	require_tech = {StoneAge : 1}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
