extends Control

onready var position = get_viewport_rect().size / 3
onready var size = Vector2(300, 300)

func _ready():
	$Background.expand = true
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
