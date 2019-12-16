extends "res://Scenes/MainInGameGUI/UIChoice.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	window = get_node("/root/InGame/Windows/CivilizationWindow")
	#print(window)
	#ani.play_backwards("choose")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(on_mouse)
	pass
