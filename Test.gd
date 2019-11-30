extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print($Area2D.get_overlapping_areas())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print($Area2D.get_overlapping_areas())
