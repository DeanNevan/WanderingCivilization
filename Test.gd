extends Node2D

signal a
signal b

# Called when the node enters the scene tree for the first time.
func _ready():
	var a = [2,5,1,3,2,11,210,123]
	print(a)
	a.sort()
	print(a)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func a():
	for i in 10:
		print(i)
	emit_signal("a")

func b():
	print("b")