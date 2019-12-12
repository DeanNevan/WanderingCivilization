extends TextureRect

onready var ani = $AnimationPlayer

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	ani.play_backwards("choose")
	ani.playback_speed = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_mouse_entered():
	if !ani.is_playing():
		$TextureProgress.fill_mode = randi() % 9
	#print("222")
	ani.play("choose", -1, 1.4)

func _on_mouse_exited():
	#print("333")
	ani.play_backwards("choose")