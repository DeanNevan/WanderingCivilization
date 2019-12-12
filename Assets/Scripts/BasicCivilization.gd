extends Node

onready var Technologies = Node.new()
onready var Races = Node.new()
onready var GreatMen = Node.new()
onready var Buildings = Node.new()
onready var Policies = Node.new()

func _ready():
	add_child(Technologies)
	add_child(Races)
	add_child(GreatMen)
	add_child(Buildings)
	add_child(Policies)
	

func _process(delta):
	pass