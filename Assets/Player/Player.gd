extends "res://Assets/Scripts/BasicCivilization.gd"

onready var Technologies = get_node("/root/InGame/WorldData/Technologies").duplicate()

func _ready():
	self.add_child(Technologies)
	#print()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
