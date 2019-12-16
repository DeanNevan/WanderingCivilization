extends TextureRect

onready var pause_texture = preload("res://Assets/Art/GUI/Icons/pause.png")
onready var normal_texture = preload("res://Assets/Art/GUI/Icons/right.png")
onready var fast_texture = preload("res://Assets/Art/GUI/Icons/fastForward.png")

enum {
	PAUSE
	NORMAL
	FAST
}

func _ready():
	texture = normal_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_time_speed():
	pass