extends Node

var contents = []
var content_range = [[0,0], [0,0]]
var bonus = []

func _ready():
	bonus.resize(get_parent().get_node("Element").get_child(0).standard_para.size() + 1)