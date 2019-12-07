extends "res://Assets/Scripts/BasicCivilization.gd"

onready var Technologies = get_node("/root/InGame/WorldData/Technologies")

func _ready():
	self.add_child(Technologies)
	#print(Technologies.get_child(0).get_child(0).name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
