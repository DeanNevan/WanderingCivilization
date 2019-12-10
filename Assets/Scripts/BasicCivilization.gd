extends Node

onready var Technologies = get_node("/root/InGame/WorldData/Technologies").duplicate()
#onready var Races = Node.new()
onready var GreatMan = Node.new()

func _ready():
	self.add_child(Technologies)
	#self.add_child(Races)
	self.add_child(GreatMan)
	

func _process(delta):
	pass